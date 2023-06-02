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
time = zeros([17000000 1]);
for i = 1:17000000
    time(i) = i/(1e12);
end

%Power in
Pin = zeros([17000000 1]);
Pin(500000:600000) =  7.38e-3;
Pin(600001:733504) = .73e-3;
Pin(1500000:1600000) = 7.38e-3;
Pin(1600001:1716333) = .73e-3;
Pin(2500000:2600000) = 7.38e-3;
Pin(2600001:2701252) = .73e-3;
Pin(3500000:3600000) =  7.38e-3;
Pin(3600001:3689406) = .73e-3;
Pin(4500000:4600000) = 7.38e-3;
Pin(4600001:4678656) = .73e-3;
Pin(5500000:5600000) = 7.38e-3;
Pin(5600001:5669880) = .73e-3;
Pin(6500000:6600000) = 7.38e-3;
Pin(6600001:6662023) = .73e-3;
Pin(7500000:7600000) = 7.38e-3;
Pin(7600001:7654517) = .73e-3;
Pin(8500000:8600000) = 7.38e-3;
Pin(8600001:8647216) = .73e-3;
Pin(9500000:9600000) = 7.38e-3;
Pin(9600001:9641022) = .73e-3;
Pin(10500000:10600000) = 7.38e-3;
Pin(10600001:10635160) = .73e-3;
Pin(11500000:11600000) = 7.38e-3;
Pin(11600001:11629601) = .73e-3;
Pin(12500000:12600000) = 7.38e-3;
Pin(12600001:12624319) = .73e-3;
Pin(13500000:13600000) = 7.38e-3;
Pin(13600001:13619381) = .73e-3;
Pin(14500000:14600000) = 7.38e-3;
Pin(14600001:14614576) = .73e-3;
Pin(15500000:15600000) = 7.38e-3;
Pin(15600001:15610061) = .73e-3;

%Write
%Calculation of Tgst Zero
a=R*C;
b=((2*K*nIc.*Pin)./(Weff*C))+((Tamb)/(R*C));

TgstZ = zeros([17000000 1]);
TgstZ(1) = Tamb;

t = inf;
max = inf;
PinMax = -inf;
Tmiddle = -inf;
Tcurrent = inf;

for i = 2:16999999
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
zInt = zeros([17000000 1]);
stored = 0;
for i = 1:16999999
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
Readin = zeros([17000000 1]);
ReadOut = zeros([17000000 1]);
phase = zeros([17000000 1]);
Transmission = zeros([17000000 1]);


for i = 1:17000000
    %constant readin power of 10 micro W
    Readin(i) = 3e-3;
    
    %read out the power and phase
    ReadOut(i) = Readin(i) * exp(-2*K*(nIa*zInt(i) + nIc*(L-zInt(i))));%Check I and R
    phase(i) = K * (nRa*zInt(i) + nRc * (L-zInt(i)));

    %Calculate the transmission percent
    Transmission(i) = (ReadOut(i)/Readin(i));
end
difference = zeros([15 1]);
middle = zeros([15 1]);
for i = 1:1:15
    difference(i) = ReadOut(i*1000000+700000) - ReadOut((i-1)*1000000+700000);
    middle(i) = ReadOut((i-1)*1000000+700000) + .5 * difference(i);
end

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
plot(time,ReadOut)
title("ReadOut");
xlabel("Time(s)")
ylabel("ReadOut(W)")