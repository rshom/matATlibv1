function res = run_at(env)
% RUN_AT runs the acoustic toolbox using an environmental struct
% instead of a env file. Then it returns results instead of writing
% to file.
    
% TODO: allow for more args to be passed
% TODO: run error checks on env file (and other files)
% TODO: delete files when done option

    write_env( env.envfil, env.model, env.TitleEnv, env.freq, env.SSP, env.Bdry, env.Pos, env.Beam, env.cInt, env.RMax);

    switch upper(env.model)
      case 'BELLHOP'
        bellhop(env.envfil);
      otherwise
        error('Model not yet supported by run_at');
    end
    
    switch env.Beam.RunType(1)
        case {'E' 'R'}
            % 'R' Ray trace run (.ray)
            % 'E' Eigenray trace run (.ray)
            res = read_rayfile(env.envfil);
        case {'I' 'S' 'C'}
            % 'I' Incoherent TL calculation (.shd)
            % 'S' Semi-coherent TL calculation (.shd)
            % 'C' Coherent TL calculation (.shd)
            plotshd([env.envfil '.shd']);
        case 'A'
            % 'A' Arrivals calculation (.arr)
        otherwise
            error('Unknown RunType');
            
    end
    %delete([env.envfil '*']);
end
