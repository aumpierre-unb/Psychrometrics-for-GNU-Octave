# Copyright (C) 2022 2023 Alexandre Umpierre
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

function [Tadiab,Wadiab]=adiabSat(h,fig=false)
    # Syntax:
    #
    # -- [Tadiab,Wadiab]=adiabSat(h[,fig])
    #
    # adiabSat computes
    #  the adiabatic saturation temperature Tadiab (in K) and
    #  the adiabatic saturation humidity Wadiab (in Kg/kg of dry air) given
    #  the specific enthalpy h (in J/kg of dry air).
    # If fig = true is given, a schematic psychrometric chart
    #  is plotted as a graphical representation
    #  of the solution.
    # psychro is a main function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the adiabatic saturation temperature given
    # # the specific enthalpy is 82.4 kJ/kg of dry air and
    # # plot a graphical representation of the
    # # answer in a schematic psychrometric chart.
    #
    # [Tadiab,Wadiab]=adiabSat(h=82.4e3,true) # parameters and returns in SI units
    #
    # See also: psychro, dewTemp, humidity, satPress, enthalpy, volume.
    foo=@(Tadiab) h-enthalpy(Tadiab,humidity(satPress(Tadiab),:));
    Tadiab=newtonraphson(foo,273.15,1e-5);
    padiab=satPress(Tadiab);
    Wadiab=humidity(padiab,:);
    v=volume(Tadiab,Wadiab);
    if fig
        [tv,wv]=buildVolume(v);
        [tb,wb]=buildWetBulbTemp(Tadiab);
        [te,we]=buildEnthalpy(h);
        [th,wh]=buildHumidity(1);
        doPlot();
        hold on;plot(tv,wv,"-.g","linewidth",2);
        hold on;plot(tb,wb,"-.b","linewidth",2);
        hold on;plot(te,we,"-.r","linewidth",2);
        hold on;plot(th,wh,"k","linewidth",2);
        hold on;plot(Tadiab,Wadiab,"or","markersize",8);
        hold on;plot([Tadiab Tadiab 60+273.15],[0 Wadiab Wadiab],"--r","linewidth",.5);
        hold off;
    end
end
