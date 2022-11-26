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

function [T,W]=buildEnthalpy(h)
    # Syntax:
    #
    # buildEnthalpy(h)
    #
    # buildEnthalpy generates a vector of
    #  humidity and dry bulb temperature
    #  with given constant specific enthalpy (in J/kg).
    # By default, constant specific enthalpy curves
    #  are ploted with red dash-doted thin lines.
    # buildEnthalpy is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    foo=@(T1) (h-enthalpy(T1,humidity(satPress(T1),:)));
    tol=h/1e3;
    T1=newtonraphson(foo,300,tol);
    foo=@(T2) (h-enthalpy(T2,0));
    T2=newtonraphson(foo,T1,tol);
    if T2>60+273.15 T2=60+273.15; end
    N=5;
    T=[];
    W=[];
    for n=1:N
        T=[T;T1+(T2-T1)/(N-1)*(n-1)];
        foo=@(W) (h-enthalpy(T(n),W));
        W=[W;newtonraphson(foo,1e-3,1)];
    end
end

