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

function [T,W]=buildWetBulbTemp(Twet)
    # Syntax:
    # -- [T,W]=buildWetBulbTemp(Twet)
    #
    # buildWetBulbTemp generates two column matrix of
    #  humidity and dry bulb temperature
    #  with given constant wet bulb temperature Twet (in K).
    # By default, constant specific volume curves
    #  are ploted with with blue solid thin lines.
    # buildWetBulbTemp is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    T1=Twet;
    if humidity(satPress(T1),:)>.03
        foo=@(T1) (.03-humidity2(humidity(satPress(Twet),:),T1,Twet));
        tol=abs(foo(50+273.15)/1e3);
        T1=newtonraphson(foo,50+273.15,tol);
    end
    foo=@(T2) (0-humidity2(humidity(satPress(Twet),:),T2,Twet));
    tol=abs(foo(50+273.15)/1e3);
    T2=newtonraphson(foo,50+273.15,tol);
    if T2>60+273.15 T2=60+273.15; end
    N=5;
    T=[];
    W=[];
    for n=1:N
        T=[T;T1+(T2-T1)/(N-1)*(n-1)];
        foo=@(W) (W-humidity2(humidity(satPress(Twet),:),T(n),Twet));
        tol=abs(foo(1e-3)/1e3);
        W=[W;newtonraphson(foo,1e-2,tol)];
    end
end
