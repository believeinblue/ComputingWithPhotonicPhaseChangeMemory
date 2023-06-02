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
time = zeros([1000000 1]);
for i = 1:1000000
    time(i) = i/(1e12);
end

%Power in with 5 "Spikes"
Pin = zeros([1000000 1]);
for i = 1:1:100000
    Pin(100000+i) =  7.38e-3;
end

for i = 1:1:700000
    Pin(i+200000) = .75e-3;
end

%Write
    %Calculation of Tgst Zero
    a=R*C;
    b=((2*K*nIc.*Pin)./(Weff*C))+((Tamb)/(R*C));

    TgstZ = zeros([1000000 1]);
    TgstZ(1) = Tamb;

    t = inf;
    max = inf;
    PinMax = -inf;
    Tmiddle = -inf;
    Tcurrent = inf;

    for i = 2:999999
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
    zInt = zeros([1000000 1]);
    stored = 0;
    for i = 1:999999
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

    figure;
    plot(zInt);
    figure;
    plot(Pin);

    b0 = false;
    b1 = false;
    b2 = false;
    b3 = false;
    b4 = false;
    b5 = false;
    b6 = false;
    b7 = false;
    b8 = false;
    b9 = false;
    b10 = false;
    b11 = false;
    b12 = false;
    b13 = false;
    b14 = false;
    b15 = true;

    zInt = round(zInt,11);
    for i = 1:800000
        if zInt(i+200000) <= 3.25238e-6 && b15 == true && b14 == false
            i
            b14 = true;
        elseif zInt(i+200000) <= 3.09333e-6 && b14 == true && b13 == false
            i
            b13 = true;
        elseif zInt(i+200000) <= 2.92619e-6 && b13 == true && b12 == false
            i
            b12 = true;
        elseif zInt(i+200000) <= 2.75680e-6 && b12 == true && b11 == false
            i
            b11 = true;
        elseif zInt(i+200000) <= 2.57853e-6 && b11 == true && b10 == false
            i
            b10 = true;
        elseif zInt(i+200000) <= 2.39441e-6 && b10 == true && b9 == false
            i
            b9 = true;
        elseif zInt(i+200000) <= 2.20445e-6 && b9 == true && b8 == false
            i
            b8 = true;
        elseif zInt(i+200000) <= 2.00878e-6 && b8 == true && b7 == false
            i
            b7 = true;
        elseif zInt(i+200000) <= 1.78531e-6 && b7 == true && b6 == false
            i
            b6 = true;
        elseif zInt(i+200000) <= 1.56433e-6 && b6 == true && b5 == false
            i
            b5 = true;
        elseif zInt(i+200000) <= 1.34325e-6 && b5 == true && b4 == false
            i
            b4 = true;
        elseif zInt(i+200000) <= 1.10952e-6 && b4 == true && b3 == false
            i
            b3 = true;
        elseif zInt(i+200000) <= .843425e-6 && b3 == true && b2 == false
            i
            b2 = true;
        elseif zInt(i+200000) <= .577280e-6 && b2 == true && b1 == false
            i
            b1 = true;
        elseif zInt(i+200000) <= .280689e-6 && b1 == true && b0 == false
            i
            b0 = true;
        elseif zInt(i+200000) <= 0 && b0 == true
            i
            break
        end
    end