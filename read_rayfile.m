function rays = read_rayfile(envfil)
    % Read data from ray file
    rayfil = [envfil '.ray'];
    fid = fopen( rayfil, 'r' );   % open the file
    if ( fid == -1 )
        disp( rayfil );
        error( 'No ray file exists; you must run BELLHOP first (with ray ouput selected)' );
    end
    
    % read header stuff
    TITLE       = fgetl(  fid );
    FREQ        = fscanf( fid, '%f', 1 );
    Nsxyz       = fscanf( fid, '%f', 3 );
    NBeamAngles = fscanf( fid, '%i', 2 );
    
    DEPTHT      = fscanf( fid, '%f', 1 );
    DEPTHB      = fscanf( fid, '%f', 1 );
    
    Type        = fgetl( fid );
    Type        = fgetl( fid );
    
    Nsx    = Nsxyz( 1 );
    Nsy    = Nsxyz( 2 );
    Nsz    = Nsxyz( 3 );
    
    Nalpha = NBeamAngles( 1 );
    Nbeta  = NBeamAngles( 2 );
    
    % Extract letters between the quotes
    nchars = strfind( TITLE, '''' );   % find quotes
    TITLE  = [ TITLE( nchars( 1 ) + 1 : nchars( 2 ) - 1 ) blanks( 7 - ( nchars( 2 ) - nchars( 1 ) ) ) ];
    TITLE  = deblank( TITLE );  % remove whitespace
    
    nchars = strfind( Type, '''' );   % find quotes
    Type   = Type( nchars( 1 ) + 1 : nchars( 2 ) - 1 );
    %Type  = deblank( Type );  % remove whitespace
    
    rays = [ ];
    for isz = 1 : Nsz
        source = [ ];
        for ibeam = 1 : Nalpha
            alpha0    = fscanf( fid, '%f', 1 );
            nsteps    = fscanf( fid, '%i', 1 );
            
            NumTopBnc = fscanf( fid, '%i', 1 );
            NumBotBnc = fscanf( fid, '%i', 1 );
            
            if isempty( nsteps ); break; end
            switch Type
              case 'rz'
                ray = fscanf( fid, '%f', [2 nsteps] );
                
                beam.r = ray( 1, : );
                beam.z = ray( 2, : );
              case 'xyz'
                ray = fscanf( fid, '%f', [3 nsteps] );
                
                beam.xs = ray( 1, 1 );
                beam.ys = ray( 2, 1 );
                beam.r = sqrt( ( ray( 1, : ) - xs ).^2 + ( ray( 2, : ) - ys ).^2 );
                beam.z = ray( 3, : );
            end
            source = [source beam];
        end	% next beam
        rays = [rays; source];
    end % next source depth
    
end

