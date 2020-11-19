function create_envfils(env,fpath)
% Create an env file and other files based on the env struct
% 
% .env: core input file
% .ati: surface height file for surface range dependent depths
% .bty: bathymetry file for bottom range dependent depths
% .ssp: sound speed profile file for range dependent profiles
% .sbp: transmitter directionality

    
    fname = [env.name '.env'];
    envfil = fopen(fullfile(fpath,fname), 'w');

    fprintf(envfil,['''' env.name '''\n']);% TITLE
    fprintf(envfil,'%0.6f\n', env.frequency);% FREQ
    fprintf(envfil,'%d\n',length(env.ssp));% NMEDIA
    
    write_sspOptions(envfil,env);       % SSPOPT

    % Write sound speed profiles

    % NOTE: SSP for bellhop can have multiple ranges. For kraken it can
    % have multiple media. Neither program supports the others option
    % in this case.

    for idx = 1:length(env.ssp)
        write_profile(envfil,env.ssp{idx})
    end
    
    if ~isempty(env.ssp{1}.r)           % range dependent SSP
        assert(length(env.ssp)==1, ...
               "Cannot have range dependence with multiple media");
        ssp = env.ssp{1};
        sspfil = fullfile(fpath,[env.name '.ssp']); 
        writessp(sspfil, ssp.r, env.c);
    end    

    % Write bottom bathymetry
    write_bottomOptions(envfil,env);       % BOTOPT SIGMA
    
    if strcmp(env.bottom_type, 'halfspace')
        error('Bottom halfspace not implimented');
        fprintf(envfil, '%0.6f\t%0.6f\t0.0\t%0.6f\t%0.6f\t/\n', ... 
                max(env.depth(2,:)), env.bottom_cp, ...
                env.bottom_density/1000, env.bottom_absorption);
    end
    
    
    if size(env.depth,2)>1              % Range dependent depth
        switch env.depth_interp
          case 'linear'
            code = 'L';
          otherwise
            error('Depth interpretation not implimented');
        end
        
        bdryfil = fullfile(fpath,[env.name '.bty']);
        writebdry(bdryfil,code,env.depth);
    end
    
    if strcmp(env.model,'kraken')
        % Phase speed limits
        fprintf(envfil,'%0.6f\t%0.6f\n',env.cLow,env.cHigh);
        fprintf(envfil,'%0.6f\n',max(env.rx_range)/1000); % RMAX (km)
        % fprintf(envfil,'%0.6f\n',0; % RMAX (km)

        flpfil = fullfile(fpath,[env.name '.flp']);
        create_flpfil(flpfil,env)
    end
    
    % Source locations
    fprintf(envfil,'%d \n', length(env.tx_depth));
    fprintf(envfil,'%0.6f /', env.tx_depth);
    fprintf(envfil,'\n');

    % Reciever locations
    fprintf(envfil,'%d \n', length(env.rx_depth));
    fprintf(envfil,'1 %0.6f /\n', max(env.rx_depth));
    fprintf(envfil,'%d \n', length(env.rx_range));
    fprintf(envfil,'%0.6f /\n', env.rx_range./1000);

    if strcmp(env.model,'bellhop')
        switch env.runtype
          case 'ray'
            runtype = 'R';
          case 'coherent'
            runtype = 'C';
          case 'incoherent'
            runtype = 'I';
          case 'semicoherent'
            runtype = 'S';
        end    

        if isempty(env.tx_directionality)
            fprintf(envfil, '''%c''\n', runcode);
        else
            fprintf(envfil, '''%c*''\n', runcode);
            error("Source directionality not implimented");% TODO
        end
        
        % Beams
        fprintf(envfil, '%d\t', env.nbeams);
        fprintf(envfil, '%0.6f\t%0.6f\t/\n', env.min_angle, env.max_angle);
        
        % Box
        fprintf(envfil, '0.0\t%0.6f\t%0.6f\n', ...
                1.01*max(env.depth(2,:)), 1.01*max(env.rx_range)/1000);

        
    end


    fclose(envfil);                     % Close out file

end


    

function create_sbpfil(fname,dir)
% Create a directionality file
    
    sbpfil = fopen(fname, 'w');
    
    [rows ~] = size(dir);
    for row=1:rows
        fprintf('%0.6f %0.6f \n', dir(row,1), dir(row,2));
    end

    fclose(atifil);

end

function create_sspfil(fname,sspRanges,sspProfiles)
% Create a range dependent SSP file
    
    [rows cols] = size(ssp);

    sspfil = fopen(fname, 'w');
    
    fprintf(sspfil, '%d \n', cols);
    fprintf(sspfil, '%0.3f \n', sspRanges);
    
    for row=1:length(rows)
        fprintf(sspfil, '%.6f \n', sspProfiles(row,:));
    end
        
    fclose(sspfil);
    
end

function create_flpfil(fname,env)
% Write field parameter file for kraken
    flpfil = fopen(fname, 'w');
    fprintf(flpfil,'''%s''\n',env.name);
    fprintf(flpfil,'''%s''\n',env.modeOpt);
    fprintf(flpfil,'%d\n',env.nmodes);
    fprintf(flpfil,'%d\n',env.nprof);
    fprintf(flpfil,'%d\n',env.rprof);
    
    fprintf(flpfil,'%d\n',1000);        % FIXME: magic number
    fprintf(flpfil,'1 %0.6f / \n',max(env.rx_range/1000.)); % ???
    
    fprintf(flpfil,'%d\n', length(env.tx_depth));
    fprintf(flpfil,'%0.6f / \n',env.tx_depth); % ???    


    fprintf(flpfil,'%d\n', length(env.rx_depth));
    fprintf(flpfil,'1 %0.6f / \n',max(env.rx_depth)); % ???    
    
    fprintf(flpfil,'%d\n', length(env.tx_depth)); % ???
    fprintf(flpfil,'%d %d / \n',0,0);     % ???
    
    fclose(flpfil);
    
end


function write_sspOptions(envfil,env)
% Write the top option line

% TODO: error checks
    
    opts = '    ';                      % place holder
    
    switch env.ssp_interp
        % SSP approximation options
        % 'N' N2-Linear approximation to SSP
        % 'C' C-Linear approximation to SSP
        % 'P' PCHIP approximation to SSP
        % 'S' Spline approximation to SSP
        % 'Q' Quadrilateral approximation to range-dependent SSP (.ssp file)
        % 'H' Hexahedral approximation to range and depth dependent SSP
        % 'A' Analytic SSP option    
      case 'n2-linear'
        opts(1) = 'N';
      case 'c-linear'
        opts(1) = 'C';
      case 'spline';
        opts(1) = 'S';
      case 'analytic'
        opts(1) = 'A';
      case 'quad'
        opts(1) = 'Q';
      otherwise
        error('Sound speed interp not implimented');
    end
    
    switch env.surface_type
        % Boundary conditions
      case 'vacuum'
        opts(2) = 'V';
      case 'rigid'
        opts(2) = 'R';
      case 'halfspace'
        opts(2) = 'A';
        error('Impliment halfspace options');
      otherwise
        error('Surface type not implimented');
    end
    
    switch env.volume_attenuation
        % Attenuation Units
      case 'ignore'
        opts(3) = ' ';
      case 'nepers/m'
        opts(3) = 'N';
      case 'dB/mkHz'
        opts(3) = 'F';
      case 'dB/m'
        opts(3) = 'M';
      case 'dB/wavelength'
        opts(3) = 'W';
      case 'Q'
        opts(3) = 'Q';
      case 'Loss tangent'
        opts(3) = 'L';
      otherwise
        error('Volume attenuation not implimented');
    end

    switch env.misc_option
    % Misc Option
    % ' ' Ignore
    % '.' Slow/robust root-finder (for KRAKENC)
    % 'A' Produce arrival time/amplitude information (for BELLHOP)
    % ???: are there more Misc options
      case 'ignore'
        opts(4) = ' ';
      otherwise
        error('Misc option not implimented.');
    end
    
    fprintf(envfil,'''%s''\n',opts);
            
end

function write_bottomOptions(envfil,env)
% Write bottom options

    opts = '  ';
    switch env.bottom_type
        % Boundary conditions
      case 'vacuum'
        opts(1) = 'V';
      case 'rigid'
        opts(1) = 'R';
      case 'halfspace'
        opts(1) = 'A';
        error('Impliment halfspace options');
      otherwise
        error('Bottom type not implimented');
    end
    
    [r c] = size(env.depth);
    if c >1
        opts(2) = '*';
    else
        opts(2) = ' ';
    end

    % Bottom Options
    
    fprintf(envfil,'''%s''\t%0.6f\n',opts, env.bottom_roughness);
    % TODO: impliment range dependent bottom            
    
end

function write_profile(envfil,ssp)
    fprintf(envfil, "0\t0.0\t%0.6f\t/\n", ssp.z(end) );% NMESH SIGMA Z(NSSP)
    if length(ssp.z)==1                 % single point
        fprintf(envfil,"%.6f\t%0.6f\t/\t\n", ...
                0.0 , env.ssp.c(1,1));  % surface
        fprintf(envfil,"%.6f\t%0.6f\t/\t\n", ...
                ssp.z , env.ssp.c(1,1)); % bottom
    else
        for idx=1:length(ssp.z)
            fprintf(envfil,"\t%.6f\t%0.6f\t/\n", ...
                    ssp.z(idx), ssp.c(idx,1));
        end
    end
end
    
