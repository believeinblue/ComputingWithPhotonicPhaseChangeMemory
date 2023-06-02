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

output = [1 16];

Matrix = zeros([16 16]);

%Loop through the different input values (xaxis)
for G = 1:16
    %Encoding of the input value with different length of pulses
    if G == 1
        LENGTH = 1000;
    elseif G == 2
        LENGTH = 1040;
    elseif G == 3
        LENGTH = 2000;
    elseif G == 4
        LENGTH = 2800;
    elseif G == 5
        LENGTH = 3900;
    elseif G == 6
        LENGTH = 5500;
    elseif G == 7
        LENGTH = 7700;
    elseif G == 8
        LENGTH = 10700;
    elseif G == 9
        LENGTH = 15000;
    elseif G == 10
        LENGTH = 21000;
    elseif G == 11
        LENGTH = 29500;
    elseif G == 12
        LENGTH = 41000;
    elseif G == 13
        LENGTH = 58000;
    elseif G == 14
        LENGTH = 81000;
    elseif G == 15
        LENGTH = 111000;
    else
        LENGTH = 150000;
    end

    %Looping through the weight values (yaxis)
    for P = 1:16
        %declaration of constants
        number = P-1;
        Pin = PowerInputGenerator(number);

        a=R*C;
        b=((2*K*nIc.*Pin)./(Weff*C))+((Tamb)/(R*C));

        TgstZ = zeros([400000 1]);
        TgstZ(1) = Tamb;

        t = inf;
        max = inf;
        PinMax = -inf;
        Tmiddle = -inf;
        Tcurrent = inf;

        %Temperature calculation
        for i = 2:399999
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
        Zint = zeros([400000 1]);
        stored = 0;
        for i = 1:399999
            %if there is no input keep current value of Zint
            if (Pin(i) == 0)
                Zint(i) = stored;
                %if there is an input
            else
                Zint(i) = (1/alpha) * log((Tm-Tamb)/(TgstZ(i) - Tamb));
                %if the Zint is less than 0 assign it 0
                if (Zint(i) < 0)
                    Zint(i) = 0;
                end
                %the new stored value is the calculated value
                stored = Zint(i);
            end
        end
        readout = ReadPcm(Zint, K, nIa, nIc, L, LENGTH);
        timeOut = zeros([length(readout) 1]);
        for q= 1:length(readout)
            timeOut(q) = q/1e12;
        end

        output(P) = trapz(timeOut(q),readout);
    end
    Matrix(:,G) = output';
end
%Variable "Matrix" holds the 16x16 multiplication table
