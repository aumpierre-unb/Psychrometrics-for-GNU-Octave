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

function [psat]=satPress(Tdry)
    # Syntax:
    #
    # [psat]=satPress(Tdry)
    #
    # satPress computes
    #  the saturation pressure (in pa)
    #  of humid air given
    #  the dry bulb temperature (in K).
    # satPress is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the saturation pressure given
    # # the dry bulb temperature is 25 °C.
    #
    # Tdry=25+273.15; # dry bulb temperature in K
    # psat=satPress(Tdry) # saturation pressure in Pa
    #
    # See also: psychro, humidity, enthalpy, volume, adiabSat.
    run("constants.m");
    if -100<=Tdry-273.15 & Tdry-273.15<0
        k=c(1)/Tdry+...
        c(2)+...
        c(3)*Tdry+...
        c(4)*Tdry^2+...
        c(5)*Tdry^3+...
        c(6)*Tdry^4+...
        c(7)*log(Tdry);
    elseif 0<=Tdry-273.15 & Tdry-273.15<=200
        k=c(8)/Tdry+...
        c(9)+...
        c(10)*Tdry+...
        c(11)*Tdry^2+...
        c(12)*Tdry^3+...
        c(13)*log(Tdry);
    else
        error("Temperature must be in the range from 173.15 K to 473.15 K");
    end
    psat=exp(k);
end

