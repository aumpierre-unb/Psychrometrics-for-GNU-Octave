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

function plotHumidity(phi,c,w)
    T1=1+273.15;
    T2=60+273.15;
    N=100;
    for n=1:N
        T(n)=T1+(T2-T1)/(N-1)*(n-1);
        psat=satPress(T(n));
        pw=psat*phi;
        W(n)=humidity(pw,:);
    end
    plot(T,W,c,"linewidth",w);
end

#{
phi=.5;plotHumidity(phi)
#}
