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
time = zeros([500000 1]);
for i = 1:500000
    time(i) = i/(1e12);
end

%trying all 16 different L shaped pulses
LShapedTransmission = zeros([16 1]);

%time of L
State = zeros([16 1]);
for i = 1:16
    State(i) = i;
end

tempt = zeros([16 1]);
tempp = zeros([16 1]);

%Power of L
PState = zeros([16 1]);
for i = 1:16
    PState(i) = .73e-3;
end

for j = 0:1:15

    %Power in encoder for each 16 different L shaped pulse.
    Pin = zeros([500000 1]);
    for i = 1:1:100000
        Pin(50000+i) =  7.38e-3;%4.65e-3;
    end

    if j == 0
        tempp(j+1) = 233504;
        for i = 1:133504
            Pin(150000+i) = .73e-3;
        end
    elseif j == 1
        tempp(j+1) = 216333;
        for i = 1:116333
            Pin(150000+i) = .73e-3;
        end
    elseif j == 2
        tempp(j+1) = 201252;
        for i = 1:101252
            Pin(150000+i) = .73e-3;
        end
    elseif j == 3
        tempp(j+1) = 189406;
        for i = 1:89406
            Pin(150000+i) = .73e-3;
        end
    elseif j == 4
        tempp(j+1) = 178656;
        for i = 1:78656
            Pin(150000+i) = .73e-3;
        end
    elseif j == 5
        tempp(j+1) = 169880;
        for i = 1:69880
            Pin(150000+i) = .73e-3;
        end
    elseif j == 6
        tempp(j+1) = 162023;
        for i = 1:62023
            Pin(150000+i) = .73e-3;
        end
    elseif j == 7
        tempp(j+1) = 154517;
        for i = 1:54517
            Pin(150000+i) = .73e-3;
        end
    elseif j == 8
        tempp(j+1) = 147216;
        for i = 1:47216
            Pin(150000+i) = .73e-3;
        end
    elseif j == 9
        tempp(j+1) = 141022;
        for i = 1:41022
            Pin(150000+i) = .73e-3;
        end
    elseif j == 10
        tempp(j+1) = 135160;
        for i = 1:35160
            Pin(150000+i) = .73e-3;
        end
    elseif j == 11
        tempp(j+1) = 129601;
        for i = 1:29601
            Pin(150000+i) = .73e-3;
        end
    elseif j == 12
        tempp(j+1) = 124319;
        for i = 1:24319
            Pin(150000+i) = .73e-3;
        end
    elseif j == 13
        tempp(j+1) = 119381;
        for i = 1:19381
            Pin(150000+i) = .73e-3;
        end
    elseif j == 14
        tempp(j+1) = 114576;
        for i = 1:14576
            Pin(150000+i) = .73e-3;
        end
    elseif j == 15
        tempp(j+1) = 110061;
        for i = 1:10061
            Pin(150000+i) = .73e-3;
        end
    end

%     %Fig C
%     stop = (20000 + j * 10000);
%     for i = 1:stop
%         Pin(500000+i) =  2.4e-3;%4.65e-3;
%     end
    
%     %Fig D
%     for i = 1:250000
%         Pin(500000+i) =  powerOfL(j+1);%4.65e-3;
%     end

    %Write
    %Calculation of Tgst Zero
    a=R*C;
    b=((2*K*nIc.*Pin)./(Weff*C))+((Tamb)/(R*C));

    TgstZ = zeros([500000 1]);
    TgstZ(1) = Tamb;

    t = inf;
    max = inf;
    PinMax = -inf;
    Tmiddle = -inf;
    Tcurrent = inf;

    for i = 2:499999
        %once the input begins, begin time.
        if(Pin(i)>Pin(i-1))
            t = 0;
            Tmiddle = -inf;
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
    zInt = zeros([500000 1]);
    stored = 0;
    for i = 1:499999
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
    Readin = zeros([500000 1]);
    ReadOut = zeros([500000 1]);
    phase = zeros([500000 1]);
    Transmission = zeros([500000 1]);


    for i = 1:500000
        %constant readin power of 10 micro W
        Readin(i) = .5e-3;

        %read out the power and phase
        ReadOut(i) = Readin(i) * exp(-2*K*(nRa*zInt(i) + nRc*(L-zInt(i))));%Check I and R
        phase(i) = K * (nIa*zInt(i) + nIc * (L-zInt(i)));

        %Calculate the transmission percent
        Transmission(i) = (ReadOut(i)/Readin(i));
    end
    Tmelting = zeros([500000 1]);
    Tmelting(1:500000) = Tm;

        %the original transmission when Zint is 0
        originalT = Transmission(1);

        %calculate the delta Transmission
        DeltaTransmission = zeros([500000 1]);
        for i = 1:500000
            DeltaTransmission(i) = (abs(Transmission(i) - originalT)/originalT)*100;
        end

        %for the better viewing window
        DeltaTransmission(1) = 30;

        %Generate a figure with the L shaped pulse and Zint for a
        %particular L pulse
        figure
        tiledlayout(2,1);
        nexttile;
        plot(time, TgstZ);
        hold on;
        plot(time,Tmelting)
        xlabel("Time(s)");
        ylabel("Temperature(K)");
        title("Temerature of the PCM During Writing");
        nexttile;
        plot(time, Pin);
        xlabel("Time(s)");
        ylabel("Power(W)");
        title("Power of Writing Signal");
end


%FigC
% plot(State,LShapedTransmission)
% title("Change of Delta Transmission with change of Pulse length");
% xlabel("Pulse length (10's of ns)")
% ylabel("Delta Transmission(%)")

% %FigD
% figure
% plot(powerOfL,LShapedTransmission)
% title("Change of Delta Transmission with change of Pulse Amplitude");
% xlabel("Pulse amplitude")
% ylabel("Delta Transmission(%)")