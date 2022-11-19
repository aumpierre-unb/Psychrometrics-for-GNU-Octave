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

function [W]=humidity2(Wsatwet,Tdry,Twet)
    # Syntax:
    #
    # [W]=humidity2(Wsatwet,Tdry,Twet)
    #
    # humidity2 computes
    #  the humidity
    #  of humid air given
    #  the saturation humidity at wet bulb temperature,
    #  the dry bulb temperature (in K) and
    #  the wet bulb temperature (in K).
    # humidity2 is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    W=((2501-2.326*(Twet-273.15))*Wsatwet-1.006*(Tdry-Twet))/...
      (2501+1.86*(Tdry-273.15)-4.186*(Twet-273.15));
end

