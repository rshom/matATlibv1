function env = mod_ssp(env,z,c)
% Change all of the values based on a new sound speed profile.

    if length(z)~=length(c)
        error('Profile lengths do not match')
    end
    
    idx = ~isnan(c);
    
    env.SSP.NMedia;
    env.SSP.z = z(idx);
    env.SSP.c = c(idx);

    env.SSP.cs      = zeros(size(env.SSP.z));% ???: S-wave
    env.SSP.rho     = ones(size(env.SSP.z));% ???: Density profile kg/m3
    env.SSP.depth = [0 env.SSP.z(end)];
    env.SSP.raw.z      = env.SSP.z;              
    env.SSP.raw.alphaR = env.SSP.c;                 % Sound speed
    env.SSP.raw.betaR  = env.SSP.cs;                % S-wave
    env.SSP.raw.rho = env.SSP.rho;                  % Density
    env.SSP.raw.alphaI = zeros(size(env.SSP.z));
    env.SSP.raw.betaI = zeros(size(env.SSP.z));
    env.SSP.cz = diff( env.SSP.c ) ./ diff(env.SSP.z);
    
end