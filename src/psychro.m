# Copyright (C) 2022 Alexandre Umpierre
#
# This file is part of psychrometrics toolbox.
# psychrometrics toolbox is free software:
# you can redistribute it and/or modify it under the terms
# of the GNU General Public License (GPL) version 3
# as published by the Free Software Foundation.
#
# psychrometrics toolbox is distributed in the hope
# that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the
# GNU General Public License along with this program
# (license GNU GPLv3.txt).
# It is also available at https://www.gnu.org/licenses/.

% References:
% 2017 ASHRAE Handbook Fundamentals Systems-International Metric System
% CHAPTER 1 PSYCHROMETRICS
% 4. THERMODYNAMIC PROPERTIES OF WATER AT SATURATION
% Publisher: American Society of Heating, Refrigerating and Air-Conditioning Engineers, 2017
% ISBN-10: ‎193920058X
% ISBN-13: ‎978-1939200587
% BiBTeX:
% @book{ashrae2017ashrae,
%   title={ASHRAE Handbook Fundamentals 2017: Inch-Pound Edition},
%   author={Ashrae},
%   isbn={9781939200587},
%   series={ASHRAE Handbook Fundamentals Systems-International Metric System},
%   url={https://books.google.com.br/books?id=6VhRswEACAAJ},
%   year={2017},
%   publisher={American Society of Heating, Refrigerating and Air-Conditioning Engineers}
% }
% Acknowledgements: Professor Brent Stephens, Ph.D. (Illinois Institute of Technology)
%   for kindly suggesting the source reference for equations.

function [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
        psychro(Tdry=-1,Twet=-1,Tdew=-1,W=-1,h=-1,v=-1,phi=-1)
    a=[Tdry,Twet,Tdew,W,h,v,phi]==-1;
    if sum(a)~=5
        error(["Function psychro demands two and only two inputs.\nUnknowns must be assigned with ':'."]);
    end
    if a==[0 0 1 1 1 1 1]
        psat=satPress(Tdry);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        Wsat=humidity(psat,:); # using default p = 101325
        W=humidity2(Wsatwet,Tdry,Twet);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 0 1 1 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 0 1 1 1]
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 0 1 1]
        foo=@(W) (h-enthalpy(Tdry,W));
        W=bissection(foo,0,1,1e-5);
        v=volume(Tdry,W,:); # using default p = 101325
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:); # using default p = 101325
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 0 1]
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
        W=bissection(foo,0,1,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:); # using default p = 101325
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 1 0]
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        pw=phi*psat;
        phi=pw/psat;
        Tdew=dewTemp(pw);
        W=humidity(pw,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 0 1 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (W-humidity2(Wsatwet,Tdry,Twet));
        Tdry=bissection(foo,1e1,1e4,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        Wsat=humidity(psat,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 0 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Tdry=bissection(foo,Twet,200+273.15,1e-5);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 1 0 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        Tdry=Twet; # initial guess
        foo=@(W) (h-enthalpy(Tdry,W));
        W=bissection(foo,0,1,1e-5);
        while W<humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+1;
            foo=@(W) (h-enthalpy(Tdry,W));
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-1;
        while W<humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.1;
            foo=@(W) (h-enthalpy(Tdry,W));
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-.1;
        while W<humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.005;
            foo=@(W) (h-enthalpy(Tdry,W));
            W=bissection(foo,0,1,1e-5);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 0 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        Tdry=Twet; # initial guess
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+1;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-1;
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.1;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-.1;
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.005;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325
            W=bissection(foo,0,1,1e-5);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 1 0]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        Tdry=Twet;
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        W=humidity2(Wsatwet,Tdry,Twet);
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,0,psat,1e-5);
        while pw/psat>phi
            Tdry=Tdry+1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-1;
        while pw/psat>phi
            Tdry=Tdry+.1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-.1;
        while pw/psat>phi
            Tdry=Tdry+.005;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
        phi=pw/psat;
    elseif a==[1 1 0 0 1 1 1]
        #{
        Dew temperature and humidity are not independent variables.
        Given one, the other is computed:
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:); # using default p = 101325
        Alternatively:
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5)
        Tdew=dewTemp(pw)
        #}
    elseif a==[1 1 0 1 0 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        v=volume(Tdry,W,:); # using default p = 101325
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 0 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (v-volume(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 1 0]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdry=Tdew;
        psat=satPress(Tdry);
        while pw/psat>phi
            Tdry=Tdry+1;
            psat=satPress(Tdry);
        end
        Tdry=Tdry-1;
        while pw/psat>phi
            Tdry=Tdry+.1;
            psat=satPress(Tdry);
        end
        Tdry=Tdry-.1;
        while pw/psat>phi
            Tdry=Tdry+.005;
            psat=satPress(Tdry);
        end
        Wsat=humidity(psat,:); # using default p = 101325
        W=humidity(pw,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 0 1 1]
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        v=volume(Tdry,W,:); # using default p = 101325
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:) # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 0 1]
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 1 0]
        Tdry=100+273.15;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325
            Tdry=Tdry-1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325
            Tdry=Tdry-.1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+.1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325
            Tdry=Tdry-.01;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Wsat=humidity(psat,:); # using default p = 101325
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 0 1]
        W=0;
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        while volume(Tdry,W,:)>v
            W=W+.01;
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        end
        W=W-.01;
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        while volume(Tdry,W,:)>v
            W=W+.001;
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        end
        W=W-.001;
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        while volume(Tdry,W,:)>v
            W=W+.00005;
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        end
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 1 0]
        pw=0;
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        foo=@(psat) (psat-satPress(Tdry));
        psat=bissection(foo,1e1,5e4,1e-5);
        while pw/psat<phi
            pw=pw+200;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-200;
        while pw/psat<phi
            pw=pw+50;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-50;
        while pw/psat<phi
            pw=pw+5;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-5;
        while pw/psat<phi
            pw=pw+.1;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
        v=volume(Tdry,W,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 1 0 0]
        pw=0;
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        foo=@(psat) (psat-satPress(Tdry));
        psat=bissection(foo,1e1,5e4,1e-5);
        while pw/psat<phi
            pw=pw+200;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-200;
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        foo=@(psat) (psat-satPress(Tdry));
        psat=bissection(foo,1e1,5e4,1e-5);
        while pw/psat<phi
            pw=pw+50;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-50;
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        foo=@(psat) (psat-satPress(Tdry));
        psat=bissection(foo,1e1,5e4,1e-5);
        while pw/psat<phi
            pw=pw+5;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        pw=pw-5;
        W=humidity(pw,:); # using default p = 101325
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
        Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
        foo=@(psat) (psat-satPress(Tdry));
        psat=bissection(foo,1e1,5e4,1e-5);
        while pw/psat<phi
            pw=pw+.1;
            W=humidity(pw,:); # using default p = 101325
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325
            psat=bissection(foo,1e1,5e4,1e-5);
        end
        h=enthalpy(Tdry,W);
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325
        rho=(1+Wsatwet)/v;
    end
    doPlot;
    hold on;plotHumidity(phi,"k",2);
    hold on;plotEnthalpy(h,"-.r",2);
    hold on;plotVolume(v,"-.g",2);
    hold on;plotWetBulbTemp(Twet,"b",2);
    hold on;plot([Tdry Twet Tdew   ],[W Wsatwet W   ],"or","markersize",8,"markerfacecolor","r");
    hold on;plot([Tdew Tdew 340],[0 W W],"--r");
    hold on;plot([Twet Twet 340],[0 Wsatwet Wsatwet],"--r");
end

#{
clear
Tdry=30+273.15;
Twet=18+273.15;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,Twet,:,:,:,:,:)

clear
Tdry=30+273.15;
Tdew=15+273.15;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,:,Tdew,:,:,:,:)

clear
Tdry=26+273.15;
W=.011;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,:,:,W,:,:,:)

clear
Tdry=26+273.15;
h=54e3;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,:,:,:,h,:,:)

clear
Tdry=26+273.15;
v=.87;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,:,:,:,:,v,:)

clear
Tdry=22+273.15;
phi=.50;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(Tdry,:,:,:,:,:,phi)

clear
Twet=19+273.15;
Tdew=15+273.15;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,Twet,Tdew,:,:,:,:)

clear
Twet=25+273.15;
W=.015;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,Twet,:,W,:,:,:)

clear
Twet=25+273.15;
h=76e3;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,Twet,:,:,h,:,:)

clear
Twet=20+273.15;
v=.88;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,Twet,:,:,:,v,:)

clear
Twet=20+273.15;
phi=.29;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,Twet,:,:,:,:,phi)

clear
Tdew=12+273.15;
h=76e3;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,Tdew,:,h,:,:)

clear
Tdew=12+273.15;
v=.88;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,Tdew,:,:,v,:)

clear
Tdew=12+273.15;
phi=.29;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,Tdew,:,:,:,phi)

clear
W=.017;
h=76e3;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,W,h,:,:)

clear
W=.017;
v=.88;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,W,:,v,:)

clear
W=.016;
phi=.27;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,W,:,:,phi)

clear
h=76e3;
v=.88;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,:,h,v,:)

clear
h=76e3;
phi=.27;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,:,h,:,phi)

clear
v=.88;
phi=.27;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,:,:,v,phi)

#}


