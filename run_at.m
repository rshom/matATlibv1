function res = run_at(env)
% RUN_AT runs the acoustic toolbox using an environmental struct
% instead of a env file. Then it returns results instead of writing
% to file.
    
% TODO: allow for more args to be passed
% TODO: run error checks on env file
% TODO: delete files when done option

    write_env( env.envfil, env.model, env.TitleEnv, env.freq, env.SSP, env.Bdry, env.Pos, env.Beam, env.cInt, env.RMax);
    switch upper(env.model)
      case 'BELLHOP'
        bellhop(env.envfil);
        res = read_rayfile(env.envfil);
      otherwise
        error('Model not yet supported by run_at');
    end
    
end
