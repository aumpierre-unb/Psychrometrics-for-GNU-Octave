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

function [T,W]=buildVolume(v)#,c="-.g",w=1)
    # Syntax:
    #
    # buildVolume(phi)
    #
    # plotVolume generates a vector of
    #  humidity and dry bulb temperature
    #  with given constant specific volume (in cu. m/kg).
    # By default, constant specific volume curves
    #  are ploted with with green dash-doted thin lines.
    # buildVolume is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    foo=@(T1) (v-volume(T1,humidity(satPress(T1),:),:));
    tol=v/1e3;
    T1=newtonraphson(foo,273.15,tol);
    foo=@(T2) (v-volume(T2,0,:));
    T2=newtonraphson(foo,T1,tol);
    if T2>60+273.15 T2=60+273.15; end
    N=5;
    T=[];
    W=[];
    for n=1:N
        T=[T;T1+(T2-T1)/(N-1)*(n-1)];
        foo=@(W) (v-volume(T(n),W,:));
        W=[W;newtonraphson(foo,1e-4,tol)];
    end
    #plot(T,W,c,"linewidth",w);
end

