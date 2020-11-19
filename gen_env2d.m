function env = gen_env2d()
% Generate an environment
    
% TODO: expand options
% TODO: include multiple standard envs for bellhop/kraken
    
% TODO: document this

% TITLE
env.name = 'std-env';
env.model = 'kraken';
env.runtype = 'coherent';

% FREQ
env.frequency = 10;                  % Hz

% Profiles
env.ssp_interp = 'c-linear';

watercolumn.sigma = 0.0;                % surface roughness
watercolumn.z = [0 3000]';              % TODO: munk profile
watercolumn.c = [1500 1500]';
watercolumn.r = [];

env.ssp = {watercolumn;
           };

% Options
env.volume_attenuation = 'dB/m';
env.misc_option = 'ignore';

% Acoustic Surface
env.surface_type = 'vacuum';            % vacuum
env.surface_profile = [];               % surface profile
env.surface_interp = 'linear';          % curvilinear/linear
env.surface_roughness = 0;

% Halfspace properties
env.surface_cp = 1500;
env.surface_cs = 0;
env.surface_rho = 1;
env.surface_alphap = 0;
env.surface_alphas = 0;

% Acoustic Basement
env.bottom_type = 'vacuum';             % vacuum/halfspace
env.bottom_roughness = 0;               % m (rms)

% Bottom halfspace properties
env.bottom_cp = 1500;
env.bottom_cs = 0;
env.bottom_rho = 1;
env.bottom_alphap = 0;
env.bottom_alphas = 0;

% Phase Speed Limits
env.cLow = 1400;
env.cHigh = 1800;

% Sources
env.tx_depth = [200];                       % m
env.tx_directionality = [];             % [(deg; dB)...]

% Recievers
env.rx_depth = 100;                      % m
env.rx_range = 100e3;                   % m

% Bathymetry
env.depth = [0;                  % range (m)
             3000];              % depth (m)
env.depth_interp = 'linear';            % curvilinear/linear

% Beams
env.min_angle = -80;                    % deg
env.max_angle = 80;                     % deg
env.nbeams = 0;                         % number of beams (0 = auto)

% Modes
env.nmodes = 7;
env.modeOpt = 'RA';                     % ???
env.nprof = 1;                          % ???
env.rprof = 0;                          % ???

end
