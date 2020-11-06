function env = clean_env(env)
% CLEAN_ENV fixes inconsistencies within the env struct.

env.SSP.depth  = [env.SSP.z(1) env.SSP.z(end)];                  % Depth range of medium

% These are the values that actually get written
env.SSP.raw.z      = env.SSP.z;              
env.SSP.raw.alphaR = env.SSP.c;                 % Sound speed
env.SSP.raw.betaR  = env.SSP.cs;                % S-wave
env.SSP.raw.rho = env.SSP.rho;                  % Density
env.SSP.raw.alphaI = zeros(size(env.SSP.raw.z));% ???: P-wave attenuation
env.SSP.raw.betaI  = zeros(size(env.SSP.raw.z));% ???: S-wave attenuation

env.SSP.cz = diff( env.SSP.c ) ./ diff(env.SSP.z);% gradient of ssp (centered-difference approximation)
                             % FIX: I don't think this should be a matrix
% Bottom Halfspace
if (env.Bdry.Bot.BC=='A')
    env.Bdry.Bot.HS.alphaR = env.Bdry.Bot.cp;
    env.Bdry.Bot.HS.betaR = env.Bdry.Bot.cs;
    env.Bdry.Bot.HS.rho = env.Bdry.Bot.rho;
    env.Bdry.Bot.HS.alphaI = env.Bdry.Bot.alphaP;             % P-wave attenuation
    env.Bdry.Bot.HS.betaI = env.Bdry.Bot.alphaS;              % S-wave attenuation
end

% Set options line
env.Beam.RunType = [env.fileType env.Beam.beamType env.Beam.beamShift env.Beam.sourceType];% NOTE: this gets broken up in write_bell

env.Beam.Box.z   = max(env.SSP.depth)+1;% Maximum depth to trace a ray (m)
env.Beam.Box.r   = env.RMax+1;       % Maximum range to trace a ray (km)

switch env.batyOn
    case true
        batyOnOff = '*';   % Look for bathymetry file under same name
    case false
        batyOnOff = ' ';   % No bathymetry file
    otherwise
        error('Invalid bathymetry option')
end


% Define option lines
env.Bdry.Top.Opt    = [env.SSP.SSPType env.Bdry.Top.BC env.AttenUnit env.VolAtten env.miscOpt];
env.Bdry.Bot.Opt    = [env.Bdry.Bot.BC batyOnOff];

% TODO: more sub options probably

if (env.Bdry.Bot.BC=='A')
    env.Bdry.Top.depth = env.SSP.depth(env.SSP.NMedia+1);% Bottom depth
end

end