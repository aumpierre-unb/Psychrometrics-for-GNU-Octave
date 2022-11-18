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

function v=volume(Tdry,W,p=101325)
    # Syntax:
    #
    # [v]=volume(Tdry,W[,p])
    #
    # volume computes
    #  the specific volume (in cu. m/kg of dry air)
    #  of humid air given
    #  the dry bulb temperature (in K),
    #  the humidity and
    #  the total pressure (in Pa).
    # By default, total pressure is assumed
    #  to be the atmospheric pressure
    #  at sea level (101325 Pa).
    # volume is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    v=0.287042*Tdry*(1+1.6078*W)/(p/1000);
end

