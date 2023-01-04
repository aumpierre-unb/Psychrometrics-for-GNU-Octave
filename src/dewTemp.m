#  Copyright (C) 2022 2023 Alexandre Umpierre
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

function [Tdew]=dewTemp(pw)
    # Syntax:
    #
    # [Tdew]=dewTemp(pw)
    #
    # dewTemp computes
    #  the dew point temperature Tdew (in K)
    #  of humid air given
    #  the water vapor pressure pw (in Pa).
    # dewTemp is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    #
    # Examples:
    # # Compute the dew temperature
    # # of humid air given
    # # the water vapor pressure is 1 kPa.
    #
    # pw=1e3; # water vapor pressure in Pa
    # Tdew=dewTemp(pw) # dew temperature at K
    #
    # See also: psychro, humidity, satPress, enthalpy, volume.
    run('constants.m');
    alpha=log(pw/1000);
    Tdew=c(14)+...
         c(15)*alpha+...
         c(16)*alpha^2+...
         c(17)*alpha^3+...
         c(18)*(pw/1000)^0.1984+273.15;
end
