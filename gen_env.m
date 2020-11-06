function env = gen_env()
% gen_env
% 
% Generate an environmental file for the acoustic toolbox. This file
% generates a base environment which can be modified to match reality.
% 
% Help Files
% BOUNCE  : https://oalib-acoustics.org/AcousticsToolbox/manual/node69.html
% BELLHOP : https://oalib-acoustics.org/AcousticsToolbox/manual/node61.html
% KRAKEN  : https://oalib-acoustics.org/AcousticsToolbox/manual/node47.html

% TODO: set up different base standards for different runs
    
% TODO: make set functions that modify related variables when changing
% TODO: check scan functions

%% Define Environment
TitleEnv = 'Standard Env File';
fname = 'std-env';
model = 'BELLHOP';
freq = 50;                              % Hertz
RMax = 101;                             % Maximum range (km)
% NOTE: For BOUNCE RMAX is number of points

% File output type
env.fileType = 'R';
% 'R' Ray trace run (.ray)
% 'E' Eigenray trace run (.ray)
% 'I' Incoherent TL calculation (.shd)
% 'S' Semi-coherent TL calculation (.shd)
% 'C' Coherent TL calculation (.shd)
% 'A' Arrivals calculation (.arr)


%% Set Options

% SSP approximation options
SSP.SSPType = 'C';
% 'N' N2-Linear approximation to SSP
% 'C' C-Linear approximation to SSP
% 'P' PCHIP approximation to SSP
% 'S' Spline approximation to SSP
% 'Q' Quadrilateral approximation to range-dependent SSP (.ssp file)
% 'H' Hexahedral approximation to range and depth dependent SSP
% 'A' Analytic SSP option

% Attenuation Units
env.AttenUnit = 'F';
% 'N' Attenuation units: nepers/m
% 'F' Attenuation units: dB/mkHz
% 'M' Attenuation units: dB/m
% 'W' Attenuation units: dB/wavelength
% 'Q' Attenuation units: Q
% 'L' Attenuation units: Loss tangent


% Volume Attention (Optional)
env.VolAtten = ' ';                         % Leave blank to ignore
% ' ' Ignore volume attenuation
% 'T' THORP attenuation
% 'F' Francois-Garrison attenuation

% Francois-Garrison Options
if (env.VolAtten=='F')                      % TODO: fill in these values
   SSP.T = 0;
   SSP.S = 0;
   SSP.pH = 0;
   SSP.z_bar = 0;
end

% Surface Boundary Condition
Bdry.Top.BC     = 'V';
% 'V' VACUUM above top.
% 'A' ACOUSTO-ELASTIC half-space.
% 'R' Perfectly RIGID.
% 'F' Reflection coefficient from a FILE (available in KRAKENC only).
% 'S' Soft-boss Twersky scatter.
% 'H' Hard-boss Twersky scatter.
% 'T' Soft-boss Twersky scatter, amplitude only.
% 'I' Hard-boss Twersky scatter, amplitude only

% TODO: Acoustic Half-Space Options

% Seafloor Boundary Condition
Bdry.Bot.BC     = 'A';
% 'V' VACUUM below bottom.
% 'A' ACOUSTO-ELASTIC half-space.
% 'R' Perfectly RIGID.
% 'F' Reflection coefficient from a FILE (available in KRAKENC only).
% 'S' Soft-boss Twersky scatter.
% 'H' Hard-boss Twersky scatter.
% 'T' Soft-boss Twersky scatter, amplitude only.
% 'I' Hard-boss Twersky scatter, amplitude only

env.batyOn = false;


% TODO: Acoustic Half-Space Options

% Misc Option
env.miscOpt = ' ';
% ' ' Ignore
% '.' Slow/robust root-finder (for KRAKENC)
% 'A' Produce arrival time/amplitude information (for BELLHOP)
% ???: are there more Misc options

% TODO: more sub options probably


%% Define Sound Speed Profile
SSP.NMedia = 1;     % Number of mediums with fluid-elastic interfaces.
                    % ???: NMedia would make some of these other values arrays
                    % it should match the rows of the following.
                    % TODO: Run error checks

% Define the sound speed profiles
%SSP.N  = [1:SSP.NMedia];
SSP.N = zeros(1,SSP.NMedia);             % Define mesh points for each medium
SSP.z  = [0:200:5000;];% Depth values each medium SSP
SSP.c = munk_profile(SSP.z);
% Sound speed
% TODO: define a function to generate munk profile
%SSP.c  = 1.0e+03 .*[ 1.5485 1.5303 1.5267 1.5178 1.5095 1.5043 1.5014 1.5001 1.5001 1.5010 1.5026 1.5046 1.5070 1.5097 1.5126 1.5156 1.5187 1.5218 1.5251 1.5284 1.5317 1.5350 1.5384 1.5418 1.5451 1.5485 1.5519; ]';
SSP.cs      = zeros(size(SSP.z));               % ???: S-wave
SSP.rho     = ones(size(SSP.z));                % ???: Density profile kg/m3

SSP.sigma  =  zeros(SSP.NMedia+1,1);      % RMS roughness at interfaces

% TODO: insert errors for when the values don't make sense

% Top Halfspace (applies if Top.Opt = 'A')
if (Bdry.Top.BC=='A')
    Bdry.Top.depth  = SSP.depth(1);     % Surface depth
    Bdry.Top.cp     = 0;                    % P-wave speed in halfspace
    Bdry.Top.cs     = 0;                    % S-wave speed in halfspace
    Bdry.Top.rho    = 0;                    % Density in halfspace

    Bdry.Top.rhoIns = 1;                % ???
    Bdry.Top.cIns   = 1.5485e+03;       % ???

    Bdry.Top.HS.alphaR = Bdry.Top.cp;
    Bdry.Top.HS.betaR = Bdry.Top.cs;
    Bdry.Top.HS.rho = Bdry.Top.rho;
    Bdry.Top.HS.alphaI = 0;             % P-wave attenuation
    Bdry.Top.HS.betaI = 0;              % S-wave attenuation
end

% Bottom Halfspace
if (Bdry.Bot.BC=='A')
    Bdry.Bot.cp     = 1600;                 % P-wave speed in halfspace
    Bdry.Bot.cs     = 0;                    % S-wave speed in halfspace
    Bdry.Bot.rho    = 1;                    % Density in halfspace
    Bdry.Bot.alphaP = 0;
    Bdry.Bot.alphaS = 0;
end

% Not used
% TODO: make sure these match or deal with better
% Bdry.Bot.depth  = 5000;
% Bdry.Bot.rhoIns = 1;
% Bdry.Bot.cIns   = 1.5519e+03;

% Source/Reciever Locations
Pos.s.z = [50 1000];                       % Source depths (m)
Pos.r.z = [0:100:5000];                 % Reciever depths (m)
Pos.r.r = [0:.1:100]';                  % Reciever ranges (km)

% NOTE: not used, but could be used for checks
Pos.Nsz = 2;                           % Number of source depths (<51)
Pos.Nrz = 1;                          % Number of source depths (<101)
Pos.Nrr = 1001;% Number of reciever ranges (<1001 and Nrz*Nrr<=50000 or 52000)

%% Bellhop Options

% Beam Type
Beam.beamType = ' ';
% 'C' Cartesian beams
% 'R' Ray centered beams
% 'S' Simple gaussian beams
% 'B' Geometric gaussian beams
% 'G' Geometric hat beams

% Beam Shift
Beam.beamShift = ' ';
% 'S' Beam shift in effect
% ' ' Beam shift not in effect

% Source Type
Beam.sourceType = ' ';
% 'R' Point source (cylindrical coordinates)
% 'X' Line source (Cartesian coordinates)

% Options for BeamType C and R only
Beam.epmult  = 1;                       % Epsilon Multipler
Beam.rLoop   = 1;                       % Range for choosing beam width
Beam.Ibwin   = 5;                       % Beam windowing parameter
Beam.Nimage  = 3;                       % Number of images


% Beam Fan
Beam.Nbeams  = 0;                   % Use 0 to calculate automatically
Beam.alpha = [-20:1:20]';           % Beam angles (neg towards surface)
Beam.deltas  = 0;    % Step sized for tracing rays (m) (0 for default)


% for SCOOTER,KRAKEN,KRAKENC,SPARC
cInt.Low = 1400;                        % Phase Speed limits
cInt.High = 1.0000e+09;                 % Phase Speed limits

Beam.Isingl  = 0;                       % ???: not used

% Put into one struct
env.envfil = fname;
env.model = model;
env.TitleEnv = TitleEnv;
env.freq = freq;
env.SSP = SSP;
env.Bdry = Bdry;
env.Pos = Pos;
env.Beam = Beam;
env.cInt = cInt;
env.RMax = RMax;

end

