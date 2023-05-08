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

function [T,W]=buildHumidity(phi)
    # Syntax:
    #
    # -- [T,W]=buildHumidity(phi)
    #
    # buildHumidity generates a two column matrix of
    #  humidity and dry bulb temperature
    #  with given constant relative humidity phi.
    # By default, constant relative humidity curves
    #  are ploted with black solid thin lines.
    # buildHumidity is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    T1=273.15;
    foo=@(T2) (.03-humidity(satPress(T2)*phi,:));
    tol=abs(foo(50+273.15)/1e3);
    T2=newtonraphson(foo,50+273.15,tol);
    if T2>60+273.15 T2=60+273.15; end
    N=20;
    T=[];
    W=[];
    for n=1:N
        T=[T;T1+(T2-T1)/(N-1)*(n-1)];
        psat=satPress(T(end));
        pw=psat*phi;
        W=[W;humidity(pw,:)];
    end
end
