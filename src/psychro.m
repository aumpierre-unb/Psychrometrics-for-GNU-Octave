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

function [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
        psychro(Tdry=-1,Twet=-1,Tdew=-1,W=-1,h=-1,v=-1,phi=-1,fig=false)
    # Syntax:
    # e.g.
    # given Tdry and W
    # unknowns must be indicated by default value syntax
    # [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(Tdry:,:,W,:,:,:)
    #
    # psychro computes
    #  the dry bulb temperature (in K),
    #  the wet bulb temperature (in K),
    #  the dew point temperature (in K),
    #  the humidit W (in kg/kg of dry air),
    #  the saturation humidity Wsat (in kg/kg of dry air),
    #  the saturation humidity at the wet bulb temperature Wsatwet (in kg/kg of dry air),
    #  the specific enthalpy h (in J/kg of dry air),
    #  the specific volume v (in cu. m/kg of dry air),
    #  the the relative humidity phi,
    #  the water vapor pressure pw (in Pa),
    #  the water saturation pressure psat (in Pa),
    #  the saturation pressure at the wet bulb temperature psatwet (in Pa) and
    #  the density rho (in kg/cu. m) given
    #  any two input arguments,
    #  except the combination of water vapor pressure and
    #  dew point temperature, which are not independent.
    # Unknowns must be indicated by default value syntax.
    # If fig = true is given, a schematic psychrometric chart
    #  is plotted as a graphical representation
    #  of the solution.
    # psychro is a main function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the dry bulb temperature,
    # # the wet bulb temperature,
    # # the dew point temperature,
    # # the humidity,
    # # the saturation humidity,
    # # the saturation humidity at wet bulb temperature,
    # # the specific enthalpy,
    # # the specific volume,
    # # the relative humidity,
    # # the water vapor pressure,
    # # the saturation pressure,
    # # the saturation pressure at wet bulb temperature and
    # # the density given
    # # the dew point temperature is 12 °C and
    # # the relative humidity is 29 %.
    #
    # # This call computes the answer and
    # # omits the psychrometric chart:
    # Tdew=12+273.15; # dew point temperarture in K
    # phi=.29; # relative humidity
    # [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,Tdew,:,:,:,phi)
    #
    # # This call computes the answer and
    # # plots a schematic psychrometric chart:
    # [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,12+273.15,:,:,:,.29,true) # inputs and outputs in SI units
    #
    # # Compute the dry bulb temperature,
    # # the wet bulb temperature,
    # # the dew point temperature,
    # # the dew point temperature
    # # the humidity,
    # # the saturation humidity,
    # # the saturation humidity at wet bulb temperature,
    # # the specific enthalpy,
    # # the specific volume,
    # # the relative humidity,
    # # the water vapor pressure,
    # # the saturation pressure,
    # # the saturation pressure at wet bulb temperature and
    # # the density given
    # # the specific enthalpy is 79.5 kJ/kg and
    # # the relative humidity is 29 % and
    # # plot a graphical representation of the
    # # answer in a schematic psychrometric chart.
    #
    # [Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,:,:,79.5e3,:,.29,true) # inputs and outputs in SI units
    #
    # See also: humidity, satPress, enthalpy, volume, adiabSat.
    a=[Tdry,Twet,Tdew,W,h,v,phi]==-1;
    if sum(a)~=5
        error(["Function psychro demands two and only two inputs.\nUnknowns must be assigned with ':'."]);
    end
    if a==[0 0 1 1 1 1 1]
        psat=satPress(Tdry);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        W=humidity2(Wsatwet,Tdry,Twet);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 0 1 1 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325 Pa
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 0 1 1 1]
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 0 1 1]
        foo=@(W) (h-enthalpy(Tdry,W));
        W=bissection(foo,0,1,1e-5);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:); # using default p = 101325 Pa
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 0 1]
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
        W=bissection(foo,0,1,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:); # using default p = 101325 Pa
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 1 0]
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        pw=phi*psat;
        phi=pw/psat;
        Tdew=dewTemp(pw);
        W=humidity(pw,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 0 1 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325 Pa
        foo=@(Tdry) (W-humidity2(Wsatwet,Tdry,Twet));
        Tdry=bissection(foo,1e1,1e4,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 0 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Tdry=bissection(foo,Twet,200+273.15,1e-5);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 1 0 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
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
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 0 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        Tdry=Twet; # initial guess
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+1;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-1;
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.1;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-.1;
        foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.005;
            foo=@(W) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
            W=bissection(foo,0,1,1e-5);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 1 0]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        Tdry=Twet;
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        W=humidity2(Wsatwet,Tdry,Twet);
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,0,psat,1e-5);
        while pw/psat>phi
            Tdry=Tdry+1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325 Pa
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-1;
        while pw/psat>phi
            Tdry=Tdry+.1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325 Pa
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-.1;
        while pw/psat>phi
            Tdry=Tdry+.005;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:); # using default p = 101325 Pa
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
        phi=pw/psat;
    elseif a==[1 1 0 0 1 1 1]
        #{
        Dew temperature and humidity are not independent variables.
        Given one, the other is computed:
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:); # using default p = 101325 Pa
        Alternatively:
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5)
        Tdew=dewTemp(pw)
        #}
    elseif a==[1 1 0 1 0 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:); # using default p = 101325 Pa
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 0 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:); # using default p = 101325 Pa
        foo=@(Tdry) (v-volume(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
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
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        W=humidity(pw,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 0 1 1]
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:) # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 0 1]
        foo=@(pw) (humidity(pw,:)-W); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 1 0]
        Tdry=100+273.15;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325 Pa
            Tdry=Tdry-1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325 Pa
            Tdry=Tdry-.1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+.1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W # using default p = 101325 Pa
            Tdry=Tdry-.01;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
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
        foo=@(pw) (W-humidity(pw,:)); # using default p = 101325 Pa
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 1 0]
        function [y,Tdry,psat]=foobar(pw,h,phi)
            W=humidity(pw,:); # using default p = 101325 Pa
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=newtonraphson(foo,pw,1);
            y=pw/psat-phi;
        end
        pw=0;
        dp=1e3;
        [y,Tdry,psat]=foobar(pw,h,phi);
        while abs(y)>1e-3
            if y<0
                pw=pw+dp;
            else
                pw=pw-dp;
                dp=dp/5;
            end
            [y,Tdry,psat]=foobar(pw,h,phi);
        end
        W=humidity(pw,:); # using default p = 101325 Pa
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        v=volume(Tdry,W,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 1 0 0]
        function [y,Tdry,psat]=foobaz(pw,v,phi)
            W=humidity(pw,:); # using default p = 101325 Pa
            foo=@(Tdry) (v-volume(Tdry,W,:)); # using default p = 101325 Pa
            Tdry=bissection(foo,-100+273.15,200+273.15,1e-5);
            foo=@(psat) (psat-satPress(Tdry));
            psat=newtonraphson(foo,pw,1);
            y=pw/psat-phi;
        end
        pw=0;
        dp=1e3;
        [y,Tdry,psat]=foobaz(pw,v,phi);
        while abs(y)>1e-3
            if y<0
                pw=pw+dp;
            else
                pw=pw-dp;
                dp=dp/5;
            end
            [y,Tdry,psat]=foobaz(pw,v,phi);
        end
        W=humidity(pw,:); # using default p = 101325 Pa
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:); # using default p = 101325 Pa
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet)); # using default p = 101325 Pa
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:); # using default p = 101325 Pa
        rho=(1+Wsatwet)/v;
        h=enthalpy(Tdry,W);
    end
    Tadiab=adiabSat(h);
    Wadiab=humidity(satPress(Tadiab),:); # using default p = 101325 Pa
    if fig
        doPlot;
        hold on;plotVolume(v,"-.g",2);
        hold on;plotWetBulbTemp(Twet,"b",2);
        hold on;plotEnthalpy(h,"-.r",2);
        hold on;plotHumidity(phi,"k",2);
        hold on;plot(Tdry,W,"or","markersize",8,"markerfacecolor","r");
        hold on;plot(Twet,Wsatwet,"ob","markersize",8);
        hold on;plot(Tadiab,Wadiab,"or","markersize",8);
        hold on;plot(Tdew,W,"ok","markersize",8);
        hold on;plot([Tdew Tdew 340],[0 W W],"--k");
        hold on;plot([Tadiab Tadiab 340],[0 Wadiab Wadiab],"--r");
        hold on;plot([Twet Twet 340],[0 Wsatwet Wsatwet],"-.b");
    end
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
phi=.37;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,:,h,:,phi)

clear
v=.88;
phi=.37;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,:,:,:,v,phi)
#}
