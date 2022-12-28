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

function [W]=humidity(pw,p=101325)
    # Syntax:
    #
    # [W]=humidity(pw[,p])
    #
    # humidity computes
    #  the humidity
    #  of humid air in (kg/kg of dry air) given
    #  the water vapor pressure (in Pa) and
    #  the total pressure (in Pa).
    # By default, total pressure is assumed
    #  to be the atmospheric pressure
    #  at sea level (101325 Pa).
    # humidity is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the humidity of humid air
    # # at atmospheric pressure given
    # # water vapor pressure is 1 kPa
    # # at 1 atm total pressure.
    #
    # pw=1e3; # water vapor pressure in Pa
    # W=humidity(pw) # saturation pressure in kg/kg of dry air
    #
    # See also: psychro, satPress, enthalpy, volume, adiabSat.
    W=0.621945*pw/(p-pw);
end

