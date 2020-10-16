% gen_env_bounce
% 
% Generate an environmental file for the acoustic toolbox. This file
% generates a base environment which can be modified to match reality.
% 
% Help Files
% BOUNCE  : https://oalib-acoustics.org/AcousticsToolbox/manual/node69.html
% BELLHOP : https://oalib-acoustics.org/AcousticsToolbox/manual/node61.html
% KRAKEN  : https://oalib-acoustics.org/AcousticsToolbox/manual/node47.html

% TODO: set up different base standards for different runs

error('this file is not finished')

%% Define Environment
TitleEnv = 'Standard Env File';
fname = 'std-env';
model = 'BELLHOP';
freq = 50;                              % Hertz
RMax = 101;                             % Maximum range (km)
                                        % ???: For BOUNCE RMAX is number of points

% File output type
fileType = 'E';
% 'R' Ray trace run (.ray)
% 'E' Eigenray trace run (.ray)
% 'I' Incoherent TL calculation (.shd)
% 'S' Semi-coherent TL calculation (.shd)
% 'C' Coherent TL calculation (.shd)
% 'A' Arrivals calculation (.arr)


%% Set Options

% SSP approximation options
SSPType = 'P';
% 'N' N2-Linear approximation to SSP
% 'C' C-Linear approximation to SSP
% 'P' PCHIP approximation to SSP
% 'S' Spline approximation to SSP
% 'Q' Quadrilateral approximation to range-dependent SSP
% 'H' Hexahedral approximation to range and depth dependent SSP
% 'A' Analytic SSP option

% Attenuation Units
AttenUnit = 'F';
% 'N' Attenuation units: nepers/m
% 'F' Attenuation units: dB/mkHz
% 'M' Attenuation units: dB/m
% 'W' Attenuation units: dB/wavelength
% 'Q' Attenuation units: Q
% 'L' Attenuation units: Loss tangent


% Volume Attention (Optional)
VolAtten = ' ';                         % Leave blank to ignore
% ' ' Ignore volume attenuation
% 'T' THORP attenuation
% 'F' Francois-Garrison attenuation

% Francois-Garrison Options
if (VolAtten=='F')                      % TODO: fill in these values
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

% TODO: Acoustic Half-Space Options

% Misc Option
miscOpt = ' ';
% ' ' Ignore
% '.' Slow/robust root-finder (for KRAKENC)
% 'A' Produce arrival time/amplitude information (for BELLHOP)
% ???: are there more Misc options

% Define option lines
Bdry.Top.Opt    = [SSPType Bdry.Top.BC AttenUnit VolAtten miscOpt];
Bdry.Bot.Opt    = Bdry.Bot.BC

 % TODO: more sub options


%% Define Sound Speed Profile
SSP.NMedia = 1;     % Number of mediums with fluid-elastic interfaces.
                    % ???: NMedia would make some of these other values arrays
                    % it should match the rows of the following.
                    % TODO: Run error checks

% these represent the different mediums and are vertical arrays
SSP.depth  = [0 5000];                  % Depth range of medium
SSP.sigma  =  0;      % RMS roughness at interface (currently ignored)
SSP.N = 51; % ???: Number of mesh values in SSP per medium but does
            % not match other values
SSP.Npts   = 26;        % ???: not used but needs to match other items

% TODO: insert errors for when the values don't make sense

SSP.z  = [0:200:5000];% Depth values for SSP

% Sound speed
SSP.c  = 1.0e+03 .*[ 1.5485 1.5303 1.5267 1.5178 1.5095 1.5043 1.5014 1.5001 1.5001 1.5010 1.5026 1.5046 1.5070 1.5097 1.5126 1.5156 1.5187 1.5218 1.5251 1.5284 1.5317 1.5350 1.5384 1.5418 1.5451 1.5485 1.5519 ]';
SSP.cs      = zeros(26,1);               % ???: S-wave
SSP.rho     = ones(26,1);                % ???: Density profile kg/m3

% ???: these actually get written
% TODO: move to bottom ???
SSP.raw.z      = SSP.z;              
SSP.raw.alphaR = SSP.c;                 % ???: is this the P-wave
SSP.raw.betaR  = SSP.cs;                % S-wave
SSP.raw.rho = SSP.rho;                  % Density
SSP.raw.alphaI = zeros(1,26);           % ???: 
SSP.raw.betaI  = zeros(1,26);           % ???: 

HV = diff( SSP.z );                     % layer thickness
SSP.cz = diff( SSP.c ) ./ HV;% gradient of ssp (centered-difference approximation)


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
    Bdry.Top.depth = SSP.depth(SSP.NMedia+1);% Bottom depth
    Bdry.Bot.cp     = 1600;                 % P-wave speed in halfspace
    Bdry.Bot.cs     = 0;                    % S-wave speed in halfspace
    Bdry.Bot.rho    = 1;                    % Density in halfspace

    Bdry.Bot.HS.alphaR = Bdry.Bot.cp;
    Bdry.Bot.HS.betaR = Bdry.Bot.cs;
    Bdry.Bot.HS.rho = Bdry.Bot.rho;
    Bdry.Bot.HS.alphaI = 0;             % P-wave attenuation
    Bdry.Bot.HS.betaI = 0;              % S-wave attenuation
end



% Not used
% Bdry.Bot.depth  = 5000;
% Bdry.Bot.rhoIns = 1;
% Bdry.Bot.cIns   = 1.5519e+03;

% Source/Reciever Locations
Pos.s.z = [1000];                       % Source depths (m)
Pos.r.z = [0:100:5000];                 % Reciever depths (m)
Pos.r.r = [0:.1:100]';                  % Reciever ranges (km)

% NOTE: not used, but could be used for checks
Pos.Nsz = 2;                            % Number of source depths (<51)
Pos.Nrz = 1;                            % Number of source depths (<101)
Pos.Nrr = 1001;                         % Number of reciever ranges (<1001 and Nrz*Nrr<=50000 or 52000)

%% Bellhop Options

% Beam Type
beamType = 'G';
% 'C' Cartesian beams
% 'R' Ray centered beams
% 'S' Simple gaussian beams
% 'B' Geometric gaussian beams
% 'G' Geometric hat beams

% Beam Shift
beamShift = ' ';
% 'S' Beam shift in effect
% ' ' Beam shift not in effect

% Source Type
sourceType = 'R';
% 'R' Point source (cylindrical coordinates)
% 'X' Line source (Cartesian coordinates)

% Set options line
Beam.RunType = [fileType beamType beamShift sourceType];% NOTE: this gets broken up in write_bell

% Options for BeamType C and R only
Beam.epmult  = 1;                       % Epsilon Multipler
Beam.rLoop   = 1;                       % Range for choosing beam width
Beam.Ibwin   = 5;                       % Beam windowing parameter
Beam.Nimage  = 3;                       % Number of images


% Beam Fan
Beam.Nbeams  = 0;                   % Use 0 to calculate automatically
Beam.alpha = [-20:1:20]';          % Beam angles (neg towards surface)
Beam.deltas  = 0;                  % Step sized for tracing rays (m) (0 for default)
Beam.Box.z   = 5500;                % Maximum depth to trace a ray (m)
Beam.Box.r   = RMax;                % Maximum range to trace a ray (km)


% for SCOOTER,KRAKEN,KRAKENC,SPARC
cInt.Low = 1500;                        % Phase Speed limits
cInt.High = 1.0000e+09;                 % Phase Speed limits

% ???: not used
Beam.Isingl  = 0;              

% Write environmental file
write_env( fname, model, TitleEnv, freq, SSP, Bdry, Pos, Beam, cInt, RMax)

