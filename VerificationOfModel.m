%Declaration of constants
nIc = .064112;
nRc = 1.74263;
nIa = .039634;
nRa = 1.72064;
C=.09860;
R=4.863e-7;
Tamb = 293.15;
Tm = 890;
Weff = .5e-6;%1.023

%Length and lamda zero
lmbdaZ = 1550e-9;
L = 3.5e-6;

%Calculation of K and alpha
K = (2*pi)/lmbdaZ;
alpha = -2 * K * nIc;

%time for 6000 units
time = zeros([6000000 1]);
for i = 1:6000000
    time(i) = i/(1e12);
end

%Power in with 5 "Spikes"
Pin = zeros([6000000 1]);
for i = 1:1:16300
    Pin(500000+i) =  3.5e-3;
    Pin(1500000+i) = 2.5e-3;
    Pin(2500000+i) = 3e-3;
    Pin(3500000+i) = 3.5e-3;
    Pin(4500000+i) = 4e-3;
end

%Fig C
% Pin(600000:700000) = 2.4e-3;
% Pin(1600000:1630000) = 2.4e-3;
% Pin(2600000:2640000) = 2.4e-3;
% Pin(3600000:3650000) = 2.4e-3;
% Pin(4600000:4750000) = .75e-3;

% %Fig D
% Pin(600000:850000) = .5e-3;
% Pin(1600000:1850000) = 1e-3;
% Pin(2600000:2850000) = 1.5e-3;
% Pin(3600000:3850000) = 2e-3;
% Pin(4600000:4850000) = 2.5e-3;

%Write
%Calculation of Tgst Zero
a=R*C;
b=((2*K*nIc.*Pin)./(Weff*C))+((Tamb)/(R*C));

TgstZ = zeros([6000000 1]);
TgstZ(1) = Tamb;

t = inf;
max = inf;
PinMax = -inf;
Tmiddle = -inf;
Tcurrent = inf;

for i = 2:5999999
    %once the input begins, begin time.
    if(Pin(i)>Pin(i-1))
        t = 0;
        Tmiddle = -inf;
        PinMax = -inf;
    end
    % before input begins the temperature is ambient
    if(t == inf)
        TgstZ(i) = Tamb;
     % if the input decreases reset time
    elseif (Pin(i) < Pin(i-1))
        t = 0;
        if(Tmiddle == -inf)
            TgstZ(i) = max + Tamb;
        else
            TgstZ(i) = Tcurrent + Tamb;
        end
        %TgstZ(i) = 2000;
        PinMax = Pin(i-1);
        if (Pin(i) ~=0)
            Tmiddle = a*b(i)*(1-exp(-(1)/a));
        end
    elseif (Pin(i) < PinMax && Pin(i) ~= 0)
        TgstZ(i) = (max * exp(-(t/1e12)/a)) + Tmiddle;
        Tcurrent = TgstZ(i) - Tamb;
        if (TgstZ(i) > (max+Tamb))
            TgstZ(i) = max + Tamb;
        end
    elseif (Pin(i) == 0)
        %this is the decay of the TgstZ
        if (Tmiddle == -inf)
            TgstZ(i) = (max * exp(-(t/1e12)/a)) + Tamb;
        else
            TgstZ(i) = (Tcurrent * exp(-(t/1e12)/a)) + Tamb;
        end
    %if input is nonzero
    else
        %calculate temperature
        TgstZ(i) = a*b(i)*(1-exp(-(t/1e12)/a)) + Tamb;
        max = TgstZ(i)-Tamb;
    end
    %incroment time
    t=t+1;
end


%Calculation of Zint
zInt = zeros([6000000 1]);
stored = 0;
for i = 1:5999999
    %if there is no input keep current value of Zint
    if (Pin(i) == 0)
        zInt(i) = stored;
    %if there is an input    
    else
        zInt(i) = (1/alpha) * log((Tm-Tamb)/(TgstZ(i) - Tamb));
        %if the Zint is less than 0 assign it 0
        if (zInt(i) < 0)
            zInt(i) = 0;
        end
        %the new stored value is the calculated value
        stored = zInt(i);
    end
end

%Read Out/In
Readin = zeros([6000000 1]);
ReadOut = zeros([6000000 1]);
phase = zeros([6000000 1]);
Transmission = zeros([6000000 1]);


for i = 1:6000000
    %constant readin power of 10 micro W
    Readin(i) = 1e-5;
    
    %read out the power and phase
    ReadOut(i) = Readin(i) * exp(-2*K*(nRa*zInt(i) + nRc*(L-zInt(i))));%Check I and R
    phase(i) = K * (nIa*zInt(i) + nIc * (L-zInt(i)));

    %Calculate the transmission percent
    Transmission(i) = (ReadOut(i)/Readin(i));
end

%the original transmission when Zint is 0
originalT = Transmission(1);

%calculate the delta Transmission
DeltaTransmission = zeros([6000000 1]);
for i = 1:6000000
    DeltaTransmission(i) = (abs(Transmission(i) - originalT)/originalT)*100;
end

%for the better viewing window
DeltaTransmission(1) = 30;

%display
tiledlayout(3,1)
nexttile
plot(time,TgstZ)
title("TgstZ");
xlabel("Time(s)")
ylabel("Temperature(k)")
nexttile
plot(time,zInt);
title("zInt");
xlabel("Time(s)")
ylabel("length(m)")
nexttile
plot(time,DeltaTransmission)
title("DeltaTransmission");
xlabel("Time(s)")
ylabel("DeltaTransmission(%)")