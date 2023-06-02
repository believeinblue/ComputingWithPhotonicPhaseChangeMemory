function [ReadOut] = ReadPcm(Zint, K, nIa, nIc, L, LENGTH)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    last = length(Zint) - 100;
    ReadOut = zeros(LENGTH,1);
    for i = 1:LENGTH
        ReadOut(i) = 3.5e-3 * exp(-2*K*(nIa*Zint(i+(last-LENGTH)) + nIc*(L-Zint(i+(last-LENGTH)))));%Check I and R
    end
%     plot(ReadOut);
%     ReadOut = mean(ReadOut);
%     if (ReadOut > 0.001065371565410)
%         number = 15;
%     elseif(ReadOut > 0.001031454522386)
%         number = 14;
%     elseif(ReadOut > 9.975837530637236e-04)
%         number = 13;
%     elseif(ReadOut > 9.637717383151679e-04)
%         number = 12;
%     elseif(ReadOut > 9.297414925989781e-04)
%         number = 11;
%     elseif(ReadOut > 8.958732869585827e-04)
%         number = 10;
%     elseif(ReadOut > 8.622505948712804e-04)
%         number = 9;
%     elseif(ReadOut > 8.271732646355273e-04)
%         number = 8;
%     elseif(ReadOut > 7.914825309446266e-04)
%         number = 7;
%     elseif(ReadOut > 7.575157665048976e-04)
%         number = 6;
%     elseif(ReadOut > 7.241104653975781e-04)
%         number = 5;
%     elseif(ReadOut > 6.891287621241826e-04)
%         number = 4;
%     elseif(ReadOut > 6.536787604229406e-04)
%         number = 3;
%     elseif(ReadOut > 6.182311736416717e-04)
%         number = 2;
%     elseif(ReadOut > 5.83787e-04)
%         number = 1;
%     else
%         number = 0;
%     end
end