function [PowerInput] = PowerInputGenerator(BitNumber)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    PowerInput = zeros(500000,1);
    for i = 1:1:100000
        PowerInput(i+100000) =  7.38e-3;
    end
    if BitNumber == 0
        for i = 1:133504
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 1
        for i = 1:116333
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 2
        for i = 1:101252
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 3
        for i = 1:89406
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 4
        for i = 1:78656
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 5
        for i = 1:69880
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 6
        for i = 1:62023
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 7
        for i = 1:54517
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 8
        for i = 1:47216
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 9
        for i = 1:41022
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 10
        for i = 1:35160
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 11
        for i = 1:29601
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 12
        for i = 1:24319
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 13
        for i = 1:19381
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 14
        for i = 1:14576
            PowerInput(200000+i) = .73e-3;
        end
    elseif BitNumber == 15
        for i = 1:10061
            PowerInput(200000+i) = .73e-3;
        end
    end
end