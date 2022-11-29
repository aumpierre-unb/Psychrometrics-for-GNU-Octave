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

function doPlot()
    # Syntax:
    #
    # doPlot()
    #
    # doPlot plots
    #  a schematic psychrometric chart with
    #  previously computed curves with
    #  constant dry bulb temperature,
    #  constant specific volume,
    #  constant specific enthalpy and
    #  constant relative humidity.
    # Edition of this file is
    #  highly not recommended.
    # doPlot is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    load 'plotData.m';
    figure;
    xlabel('Dry Bulb Temperature (K)');
    ylabel('Humidity (kg vapor / kg dry air)');
    axis([0+273.15 60+273.15 0 .03]);
    set(gca,...
        'fontsize',16,...
        'box','off',...
        'yaxislocation','right');

    for i=1:size(uv,2)/2
        hold on;plot(uv(:,2*(i-1)+1),uv(:,2*(i-1)+2),'-.g','color',[29/256 139/256 32/256],'linewidth',1.2);
    end
    text(286.8,.0180,'0.86 cu.m/kg','color','#1D8B20');
    text(282.0,.0135,'0.84 cu.m/kg','color','#1D8B20');

    for i=1:size(uT,2)/2
        hold on;plot(uT(:,2*(i-1)+1),uT(:,2*(i-1)+2),'-b','linewidth',1.2);
    end
    text(293.3,.0205,'25 °C','color','b');
    text(298.3,.0275,'30 °C','color','b')

    for i=1:size(ue,2)/2
        hold on;plot(ue(:,2*(i-1)+1),ue(:,2*(i-1)+2),'-.r','linewidth',1.2);
    end
    text(273,.0065,'20 kJ/kg','color','r');
    text(277,.0084,'30 kJ/kg','color','r');

    for i=1:size(uh,2)/2
        hold on;plot(uh(:,2*(i-1)+1),uh(:,2*(i-1)+2),'-k','linewidth',1.2);
    end
    text(308,.028,'80 %','color','k');
    text(313.2,.028,'60 %','color','k');
    text(321,.028,'40 %','color','k');

    for i=1:size(uH,2)/2
        hold on;plot(uH(:,2*(i-1)+1),uH(:,2*(i-1)+2),'color','#4B4B4B','linewidth',1.2);
    end
    text(326.6,.028 ,'30 %','color','#4B4B4B');
    text(328.6,.0255,'25 %','color','#4B4B4B');
    text(328.6,.020 ,'20 %','color','#4B4B4B');
    text(328.6,.015 ,'15 %','color','#4B4B4B');
    text(328.6,.0098,'10 %','color','#4B4B4B');
    text(328.6,.0046, '5 %','color','#4B4B4B');
end
