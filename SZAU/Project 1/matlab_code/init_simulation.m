"Initializing simulation"

global data;
% Constants
data.A2 = 280; % cm2
data.C1 = 0.75;
data.alpha = [20, 16];
data.Vp = [18085, 45.1416*data.A2];
data.thau = 250;

% Starting condition: [V1,V2]
data.V0 = [0,0];
% data.V0 = data.Vp;

% Limitations
data.V1_MIN = 0;
data.V2_MIN = 0;
data.V1_MAX = 200000;
data.V2_MAX = 100000;
data.Fin_MAX = 200;
data.Fin_MIN = 0;
data.max_DUs = 1; % Max delta U per second

global time_step; time_step = 10; %s
global steps_per_second; steps_per_second = 1/time_step; %Hz

V1_last = data.V0(1);
V2_last = data.V0(2);
