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

function [Tadiab]=adiabSat(h,fig=false)
    # Syntax:
    # [Tadiab]=adiabSat(h[,fig])
    #
    # adiabSat computes
    #  the temperature of adiabatic saturation Tadiab (in K) given
    #  the specific enthalpy h (in J/kg of dry air).
    # If fig = true is given, a schematic psychrometric chart
    #  is plotted as a graphical representation
    #  of the solution.
    # psychro is a main function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the temperature of adiabatic saturation given
    # # the specific enthalpy is 82.4 kJ/kG of dry air and
    # # plot a graphical representation of the
    # # answer in a schematic psychrometric chart.
    #
    # h=82.4e3; # specific enthalpy in J/kG
    # Tadiab=adiabSat(h,true) # temperature of adiabatic saturation in K
    #
    # See also: psychro, humidity, satPress, enthalpy, volume.
    foo=@(Tadiab) h-enthalpy(Tadiab,humidity(satPress(Tadiab),:));
    Tadiab=newtonraphson(foo,273.15,1e-5);
    psat=satPress(Tadiab);
    Wsat=humidity(psat,:);
    if fig
        doPlot;
        hold on;plotHumidity(1,"k",2);
        hold on;plotEnthalpy(h,"-.r",2);
        hold on;plot(Tadiab,Wsat,"or",...
                     "markersize",8,...
                     "markerfacecolor","r");
    end
end

