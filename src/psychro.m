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
        psychro(Tdry=NaN,Twet=NaN,Tdew=NaN,W=NaN,h=NaN,v=NaN,phi=NaN,fig=false)
    # Syntax:
    # -- [~,~,~,~,W,~,~,~,h,v]=psychro(Tdry=300,Twet=295)
    # -- [~,~,~,Tadiab,~,~,Wsatwet,Wadiab]=psychro(Tdry=298,:,:,:,:,:,phi=0.50,true)
    # -- [Tdry,Twet,Tdew,~,~,~,~,~,~,~,phi,pw]=psychro(:,:,:,:,h=40e3,v=0.85)
    # -- [Tdry,~,~,~,~,~,~,~,~,~,~,~,psat,psatwet,rho]=psychro(:,:,:,:,h=55e3,v=0.87,:,true)
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
    #  any two parameters among
    #  the dry bulb temperature Tdry (in K),
    #  the wet bulb temperature Twet (in K),
    #  the dew point temperature Tdew (in K),
    #  the humidit W (in kg/kg of dry air),
    #  the specific enthalpy h (in J/kg of dry air),
    #  the specific volume v (in cu. m/kg of dry air) and
    #  the the relative humidity phi,
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
    # # the relative humidity is 29 %:
    # [Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
    # psychro(:,:,Tdew=22+273.15,:,:,:,phi=0.29) # parameters and returns in SI units
    #
    # # 8.5 cubic meters of humid air at
    # # dry bulb temperature of 293 K and
    # # wet bulb temperature of 288 K
    # # is subjected to two cycles of
    # # heating to 323 and adiabatic saturation.
    # # Compute the energy and water vapor demands.
    # # Assume the amount of dry air is constant.
    #
    # # All parameters and returns in SI units
    # # The initial condition is
    # [~,~,~,~,W1,~,~,~,h1,v1]=psychro(Tdry1=293,Twet1=288,:,:,:,:,:,true)
    #
    # # The thermodynamic state after the first heating is
    # [~,~,~,~,~,~,~,~,h2,v2]=psychro(Tdry2=323,:,:,W2=W1,:,:,:,true)
    #
    # # The thermodynamic state the after first adiabatic saturation is
    # [Tdry3,W3]=adiabSat(h3=h2)
    # [~,~,~,~,~,~,~,~,~,v3]=psychro(Tdry3,:,:,W3)
    #
    # # The thermodynamic state after the second heating is
    # [~,~,~,~,~,~,~,~,h4,v4]=psychro(Tdry4=323,:,:,W4=W3,:,:,:,true)
    #
    # # The thermodynamic state the after second adiabatic saturation is
    # [Tdry5,W5]=adiabSat(h5=h4)
    # [~,~,~,~,~,~,~,~,~,v5]=psychro(Tdry5,:,:,W5)
    #
    # # The energy and water vapor demands are
    # (h5-h1)*(8.5/v1) # demand of energy
    # (W5-W1)*(8.5/v1) # demand of water vapor
    #
    # See also: humidity, satPress, enthalpy, volume, adiabSat.
    a = isnan([Tdry, Twet, Tdew, W, h, v, phi])~=0;
    if sum(a)~=5
        error("psychro demands two and only two parameters.\nUnknowns must be assigned with ':'.");
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
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
        Tdew=dewTemp(pw);
        phi=pw/psat;
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 0 1 1 1 1]
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        W=humidity(pw,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 0 1 1 1]
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,1e3,tol);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 0 1 1]
        foo=@(W) (h-enthalpy(Tdry,W));
        tol=h/1e3;
        W=newtonraphson(foo,1e-2,tol);
        v=volume(Tdry,W,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
        W=humidity(pw,:);
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[0 1 1 1 1 0 1]
        foo=@(W) (v-volume(Tdry,W,:));
        tol=v/1e3;
        W=newtonraphson(foo,1e-2,tol);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
        W=humidity(pw,:);
        phi=pw/psat;
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
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
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdry,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 0 0 1 1 1 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        W=humidity(pw,:);
        foo=@(Tdry) (W-humidity2(Wsatwet,Tdry,Twet));
        tol=W/1e3;
        Tdry=newtonraphson(foo,Twet,tol);
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
        tol=W/1e3;
        pw=newtonraphson(foo,psatwet,tol);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Tdry=newtonraphson(foo,Twet,tol);
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
        tol=h/1e3;
        W=newtonraphson(foo,Wsatwet,tol);
        while W<humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+5e-3;
            foo=@(W) (h-enthalpy(Tdry,W));
            tol=h/1e3;
            W=newtonraphson(foo,Wsatwet,tol);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
        Tdew=dewTemp(pw);
        phi=pw/psat;
    elseif a==[1 0 1 1 1 0 1]
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        Tdry=Twet;
        foo=@(W) (v-volume(Tdry,W,:));
        tol=v/1e3;
        W=newtonraphson(foo,Wsatwet,tol);
        while W>humidity2(Wsatwet,Tdry,Twet)
            Tdry=Tdry+1e-1;#5e-3;
            foo=@(W) (v-volume(Tdry,W,:));
            tol=v/1e3;
            W=newtonraphson(foo,Wsatwet,tol);
        end
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        rho=(1+Wsatwet)/v;
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
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
        tol=W/1e3;
        pw=newtonraphson(foo,psat,tol);
        while pw/psat>phi
            Tdry=Tdry+5e-3;
            psat=satPress(Tdry);
            Wsat=humidity(psat,:);
            W=humidity2(Wsatwet,Tdry,Twet);
            foo=@(pw) (W-humidity(pw,:));
            tol=W/1e3;
            pw=newtonraphson(foo,psat,tol);
        end
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
        phi=pw/psat;
    elseif a==[1 1 0 0 1 1 1]
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        w=humidity(pw,:);
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,1e3,tol);
        tdew=dewTemp(pw);
        error("Dew point temperature and humidity\nare not independent variables.\nFor %g kg/kg humidity,\ndew point temperature is %g K, and\nfor %g K dew point tempearature,\nhumidity is %g kg/kg.",W,tdew,Tdew,w);
    elseif a==[1 1 0 1 0 1 1]
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        W=humidity(pw,:);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        tol=h/1e3;
        Tdry=newtonraphson(foo,Tdew,tol);
        psat=satPress(Tdry);
        phi=pw/psat;
        v=volume(Tdry,W,:);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 0 1]
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        W=humidity(pw,:);
        foo=@(Tdry) (v-volume(Tdry,W));
        tol=v/1e3;
        Tdry=newtonraphson(foo,Tdew,tol);
        psat=satPress(Tdry);
        phi=pw/psat;
        h=enthalpy(Tdry,W);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdry,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 0 1 1 1 0]
        foo=@(pw) (Tdew-dewTemp(pw));
        tol=Tdew/1e3;
        pw=newtonraphson(foo,1e3,tol);
        foo=@(Tdry) (phi-pw/satPress(Tdry));
        tol=phi/1e3;
        Tdry=newtonraphson(foo,Tdew,tol);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        W=humidity(pw,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 0 1 1]
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,1e3,tol);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (h-enthalpy(Tdry,W));
        tol=h/1e3;
        Tdry=newtonraphson(foo,Tdew,tol);
        v=volume(Tdry,W,:);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:)
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 0 1]
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,1e3,tol);
        Tdew=dewTemp(pw);
        foo=@(Tdry) (v-volume(Tdry,W,:));
        tol=v/1e3;
        Tdry=newtonraphson(foo,Tdew,tol);
        h=enthalpy(Tdry,W);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdry,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 0 1 1 0]
        foo=@(Tdry) (W-humidity(phi*satPress(Tdry),:));
        tol=W/1e3;
        Tdry=newtonraphson(foo,50+273.15,tol);
        psat=satPress(Tdry);
        pw=phi*psat;
        Wsat=humidity(psat,:);
        h=enthalpy(Tdry,W);
        v=volume(Tdry,W,:);
        Tdew=dewTemp(pw);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 0 1]
        W=1e-2;
        dW=W;
        foo=@(Tdry) (v-volume(Tdry,W));
        tol=v/1e3;
        Tdry=newtonraphson(foo,50+273.15,tol);
        while abs(h-enthalpy(Tdry,W))>h/1e3
            if h>enthalpy(Tdry,W)
                W=W+dW;
            else
                W=W-dW;
                dW=dW/2;
            end
            foo=@(Tdry) (v-volume(Tdry,W));
            Tdry=newtonraphson(foo,50+273.15,tol);
        end
        foo=@(pw) (W-humidity(pw,:));
        tol=W/1e3;
        pw=newtonraphson(foo,1e3,tol);
        Tdew=dewTemp(pw);
        psat=satPress(Tdry);
        Wsat=humidity(psat,:);
        phi=pw/psat;
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdry,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 0 1 0]
        function [y,Tdry,psat]=foobar(pw,h,phi)
            W=humidity(pw,:);
            foo=@(Tdry) (h-enthalpy(Tdry,W));
            tol=h/1e3;
            Tdry=newtonraphson(foo,50+273.15,tol);
            foo=@(psat) (psat-satPress(Tdry));
            tol=satPress(Tdry)/1e3;
            psat=newtonraphson(foo,pw,tol);
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
                dp=dp/2;
            end
            [y,Tdry,psat]=foobar(pw,h,phi);
        end
        W=humidity(pw,:);
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        v=volume(Tdry,W,:);
        rho=(1+Wsatwet)/v;
    elseif a==[1 1 1 1 1 0 0]
        function [y,Tdry,psat]=foobaz(pw,v,phi)
            W=humidity(pw,:);
            foo=@(Tdry) (v-volume(Tdry,W,:));
            tol=v/1e3;
            Tdry=newtonraphson(foo,50+273.15,tol);
            foo=@(psat) (psat-satPress(Tdry));
            tol=satPress(Tdry)/1e3;
            psat=newtonraphson(foo,pw,tol);
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
                dp=dp/2;
            end
            [y,Tdry,psat]=foobaz(pw,v,phi);
        end
        W=humidity(pw,:);
        Tdew=dewTemp(pw);
        Wsat=humidity(psat,:);
        foo=@(Twet) (W-humidity2(humidity(satPress(Twet),:),Tdry,Twet));
        tol=W/1e3;
        Twet=newtonraphson(foo,Tdew,tol);
        psatwet=satPress(Twet);
        Wsatwet=humidity(psatwet,:);
        rho=(1+Wsatwet)/v;
        h=enthalpy(Tdry,W);
    end
    Tadiab=adiabSat(h);
    Wadiab=humidity(satPress(Tadiab),:);
    if fig
        [tv,wv]=buildVolume(v);
        [tb,wb]=buildWetBulbTemp(Twet);
        [te,we]=buildEnthalpy(h);
        [th,wh]=buildHumidity(phi);
        run('doPlot.m');
        hold on
        plot(tv,wv,'color','#1D8B20','linewidth',2);
        plot(tb,wb,'b','linewidth',2);
        plot(te,we,'color','red','linewidth',2);
        plot(th,wh,'k','linewidth',2);
        plot(Tdry,W,'or','markersize',8,'markerfacecolor','r');
        plot(Twet,Wsatwet,'ob','markersize',8);
        plot(Tadiab,Wadiab,'or','markersize',8);
        plot(Tdew,W,'ok','markersize',8);
        if Wsat>.03
            wsat=.03;
            hold on;plot([Tdry Tdry],[0 wsat],'-.k','linewidth',.5);
        else
            wsat=Wsat;
            hold on;plot(Tdry,wsat,'ok','markersize',8);
            hold on;plot([Tdry Tdry 60+273.15],[0 wsat wsat],'-.k','linewidth',.5);
        end
        plot([Tdew Tdew 60+273.15],[0 W W],'--k','linewidth',.5);
        plot([Tadiab Tadiab 60+273.15],[0 Wadiab Wadiab],'--r','linewidth',.5);
        plot([Twet Twet 60+273.15],[0 Wsatwet Wsatwet],'-.b','linewidth',.5);
        hold off;
    end
end
