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

function plotEnthalpy(h,c,w)
    foo=@(T1) (h-enthalpy(T1,humidity(satPress(T1),:)));
    T1=bissection(foo,-99+273.15,199+273.15,1e-5);
    foo=@(T2) (h-enthalpy(T2,0));
    T2=bissection(foo,199+273.15,-99+273.15,1e-5);
    N=10;
    for n=1:N
        T(n)=T1+(T2-T1)/(N-1)*(n-1);
        foo=@(W) (h-enthalpy(T(n),W));
        W(n)=bissection(foo,0,1,1e-5);
    end
    plot(T,W,c,"linewidth",w);
end

#{
h=76e3;plotEnthalpy(h)
#}
