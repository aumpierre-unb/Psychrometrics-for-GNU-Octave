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

function [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
        psychro(Tdry=-1,Twet=-1,Tdew=-1,W=-1,h=-1,v=-1,phi=-1,fig=false)
    # Syntax:
    # e.g.
    # given Tdry and W
    # unknowns must be indicated by default value syntax
    # [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(Tdry:,:,W,:,:,:[,fig=false])
    #
    # psychro computes
    #  the dry bulb temperature Tdry (in K),
    #  the wet bulb temperature Twet (in K),
    #  the dew point temperature Tdew (in K),
    #  the adiabatic saturation temperature Tadiab (in K),
    #  the humidit W (in kg/kg of dry air),
    #  the saturation humidity Wsat (in kg/kg of dry air),
    #  the saturation humidity at the wet bulb temperature Wsatwet (in kg/kg of dry air),
    #  the adiabatic saturation humidity Wadiab (in kg/kg of dry air),
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
    # # the adiabatic saturation temperature,
    # # the humidity,
    # # the saturation humidity,
    # # the saturation humidity at wet bulb temperature,
    # # the adiabatic saturation humidity,
    # # the specific enthalpy,
    # # the specific volume,
    # # the relative humidity,
    # # the water vapor pressure,
    # # the saturation pressure,
    # # the saturation pressure at wet bulb temperature and
    # # the density given
    # # the dew point temperature is 22 °C and
    # # the relative humidity is 29 %.
    #
    # # This call computes the answer and
    # # omits the psychrometric chart:
    # Tdew=22+273.15; # dew point temperarture in K
    # phi=.29; # relative humidity
    # [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,Tdew,:,:,:,phi)
    #
    # # This call computes the answer and
    # # plots a schematic psychrometric chart:
    # [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,22+273.15,:,:,:,.29,true) # inputs and outputs in SI units
    #
    # # Compute the dry bulb temperature,
    # # the wet bulb temperature,
    # # the dew point temperature,
    # # the adiabatic saturation temperature,
    # # the humidity,
    # # the saturation humidity,
    # # the saturation humidity at wet bulb temperature,
    # # the adiabatic saturation humidity,
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
    # [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,:,:,79.5e3,:,.29,true) # inputs and outputs in SI units
    #
    # # 8.5 cubic meters of humid air at
    # # dry bulb temperature of 293 K and
    # # wet bulb temperature of 288 K
    # # is subjected to two cycles of
    # # heating to 323.15 K and adiabatical saturation.
    # # Compute the energy and the water vapor demands.
    #
    # # In a heating process, humidity is constant.
    # # In a adiabatic saturation, specific enthalpy is constant.
    # # The initial condition is
    # Tdry1=293.15;
    # Twet1=288.15;
    # [~,~,~,~,W1,~,~,~,h1,v1]=...
    # psychro(Tdry1,Twet1,:,:,:,:,:,true)
    #
    # # For the first heating one has:
    # Tdry2=323.15
    # W2=W1
    # [~,~,~,~,~,~,~,~,h2,v2]=...
    # psychro(Tdry2,:,:,W2,:,:,:,true)
    # # For the first saturation one has
    # h3=h2
    # [Tdry3,W3]=adiabSat(h3)
    # [~,~,~,~,~,~,~,~,~,v3]=...
    # psychro(Tdry3,:,:,W3)
    #
    # # For the second heating one has:
    # Tdry4=323.15
    # W4=W3
    # [~,~,~,~,~,~,~,~,h4,v4]=...
    # psychro(Tdry4,:,:,W4,:,:,:,true)
    # # For the second saturation one has
    # h5=h4
    # [Tdry5,W5]=adiabSat(h5)
    # [~,~,~,~,~,~,~,~,~,v5]=...
    # psychro(Tdry5,:,:,W5)
    #
    # # The demands of energy and water vapor are
    # (h5-h1)*(8.5/v1) # demand of energy
    # (W5-W1)*(8.5/v1) # demand of water vapor
    #
    # See also: humidity, satPress, enthalpy, volume, adiabSat.
    a=[Tdry,Twet,Tdew,W,h,v,phi]==-1;
    if sum(a)~=5
        error(["Function psychro demands two and only two inputs.\nUnknowns must be assigned with ':'."]);
    end
    if a==[0 0 1 1 1 1 1]
        psat=satPress(Tdry);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        Wsat=humidity(psat,:);
        W=humidity2(Wsatwet,Tdry,Twet);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 0 1 1 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 0 1 1 1]
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 0 1 1]
        foo=@(W) (h-enthalpy(Tdry,W));
        W=bissection(foo,0,1,1e-5);
        v=volume(Tdry,W,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        foo=@(pw) (humidity(pw,:)-W);
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:);
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 0 1]
        foo=@(W) (v-volume(Tdry,W,:));
        W=bissection(foo,0,1,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        foo=@(pw) (humidity(pw,:)-W);
        pw=bissection(foo,0,psat,1e-5);
        W=humidity(pw,:);
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 1 0]
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        pw=phi*psat;
        phi=pw/psat;
        Tdew=dewTemp(pw);
        W=humidity(pw,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 0 1 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:);
        foo=@(Tdry) (W-humidity2(Wsatwet,Tdry,Twet));
        Tdry=bissection(foo,1e1,1e4,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 0 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Tdry=bissection(foo,Twet,200+273.15,1e-5);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 1 1 0 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        Tdry=Twet;
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
        Wsat=humidity(psat,:);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 0 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        Tdry=Twet;
        foo=@(W) (v-volume(Tdry,W,:));
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+1;
            foo=@(W) (v-volume(Tdry,W,:));
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-1;
        foo=@(W) (v-volume(Tdry,W,:));
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.1;
            foo=@(W) (v-volume(Tdry,W,:));
            W=bissection(foo,0,1,1e-5);
        end
        Tdry=Tdry-.1;
        foo=@(W) (v-volume(Tdry,W,:));
        W=bissection(foo,0,1,1e-5);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+.005;
            foo=@(W) (v-volume(Tdry,W,:));
            W=bissection(foo,0,1,1e-5);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,0,psat,1e-5);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 1 0]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        Tdry=Twet;
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        W=humidity2(Wsatwet,Tdry,Twet);
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,0,psat,1e-5);
        while pw/psat>phi
            Tdry=Tdry+1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:);
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:));
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-1;
        while pw/psat>phi
            Tdry=Tdry+.1;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:);
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:));
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdry=Tdry-.1;
        while pw/psat>phi
            Tdry=Tdry+.005;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:);
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:));
            pw=bissection(foo,0,psat,1e-5);
        end
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
        phi=pw/psat;
    elseif a==[1 1 0 0 1 1 1]
        #{
        Dew temperature and humidity are not independent variables.
        Given one, the other is computed:
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:);
        Alternatively:
        foo=@(pw) (humidity(pw,:)-W);
        pw=bissection(foo,1e1,1e4,1e-5)
        Tdew=dewTemp(pw)
        #}
    elseif a==[1 1 0 1 0 1 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5)
        W=humidity(pw,:);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        v=volume(Tdry,W,:);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 0 1]
        foo=@(pw) (dewTemp(pw)-Tdew);
        pw=bissection(foo,1e1,1e4,1e-5);
        W=humidity(pw,:);
        foo=@(Tdry) (v-volume(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        psat=satPress(Tdry);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
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
        Wsat=humidity(psat,:);
        W=humidity(pw,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 0 1 1]
        foo=@(pw) (humidity(pw,:)-W);
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        v=volume(Tdry,W,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:)
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 0 1]
        foo=@(pw) (humidity(pw,:)-W);
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (v-volume(Tdry,W,:));
        Tdry=bissection(foo,Tdew,200+273.15,1e-5);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 1 0]
        Tdry=100+273.15;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W
            Tdry=Tdry-1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W
            Tdry=Tdry-.1;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Tdry=Tdry+.1;
        psat=satPress(Tdry);
        pw=phi*psat;
        while humidity(pw,:)>W
            Tdry=Tdry-.01;
            psat=satPress(Tdry);
            pw=phi*psat;
        end
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
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
        foo=@(pw) (W-humidity(pw,:));
        pw=bissection(foo,1e1,1e4,1e-5);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 1 0]
        function [y,Tdry,psat]=foobar(pw,h,phi)
            W=humidity(pw,:);
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
        W=humidity(pw,:);
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 1 0 0]
        function [y,Tdry,psat]=foobaz(pw,v,phi)
            W=humidity(pw,:);
            foo=@(Tdry) (v-volume(Tdry,W,:));
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
        W=humidity(pw,:);
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        Twet=bissection(foo,Tdew,Tdry,1e-5);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
        h=enthalpy(Tdry,W);
    end
    Tadiab=adiabSat(h);
    Wadiab=humidity(satPress(Tadiab),:);
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
