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

function [T,W]=plotWetBulbTemp(Twet)
    # Syntax:
    #
    # plotWetBulbTemp(Twet)
    #
    # plotWetBulbTemp generates a vector of
    #  humidity and dry bulb temperature
    #  with given constant wet bulb temperature (in K).
    # By default, constant specific volume curves
    #  are ploted with with blue solid thin lines.
    # plotWetBulbTemp is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    T1=Twet;
    foo=@(T2) (0-humidity2(humidity(satPress(Twet),:),T2,Twet));
    T2=newtonraphson(foo,273.15,1e-5);
    if T2>60+273.15 T2=60+273.15; end
    N=5;
    for n=1:N
        T(n)=T1+(T2-T1)/(N-1)*(n-1);
        foo=@(W) (W-humidity2(humidity(satPress(Twet),:),T(n),Twet));
        W(n)=newtonraphson(foo,1e-4,1e-5);
    end
end

