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
    figure;
    plotHumidity(.05,"k",1);
    hold on;plotHumidity(.1,"k",1);
    hold on;plotHumidity(.2,"k",1);
    hold on;plotHumidity(.4,"k",1);
    hold on;plotHumidity(.6,"k",1);
    hold on;plotHumidity(.8,"k",1);
    hold on;plotHumidity(1,"k",1);
    hold on;plotEnthalpy(10e3,"-.r",1);
    hold on;plotEnthalpy(20e3,"-.r",1);
    hold on;plotEnthalpy(30e3,"-.r",1);
    hold on;plotEnthalpy(40e3,"-.r",1);
    hold on;plotEnthalpy(50e3,"-.r",1);
    hold on;plotEnthalpy(60e3,"-.r",1);
    hold on;plotEnthalpy(70e3,"-.r",1);
    hold on;plotEnthalpy(80e3,"-.r",1);
    hold on;plotEnthalpy(90e3,"-.r",1);
    hold on;plotEnthalpy(100e3,"-.r",1);
    hold on;plotEnthalpy(110e3,"-.r",1);
    hold on;plotEnthalpy(120e3,"-.r",1);
    hold on;plotEnthalpy(130e3,"-.r",1);
    hold on;plotVolume(.78,"-.g",1);
    hold on;plotVolume(.80,"-.g",1);
    hold on;plotVolume(.82,"-.g",1);
    hold on;plotVolume(.84,"-.g",1);
    hold on;plotVolume(.86,"-.g",1);
    hold on;plotVolume(.88,"-.g",1);
    hold on;plotVolume(.90,"-.g",1);
    hold on;plotVolume(.92,"-.g",1);
    hold on;plotVolume(.94,"-.g",1);
    hold on;plotVolume(.96,"-.g",1);
    hold on;plotWetBulbTemp(5+273.15,"b",1);
    hold on;plotWetBulbTemp(10+273.15,"b",1);
    hold on;plotWetBulbTemp(15+273.15,"b",1);
    hold on;plotWetBulbTemp(20+273.15,"b",1);
    hold on;plotWetBulbTemp(25+273.15,"b",1);
    hold on;plotWetBulbTemp(30+273.15,"b",1);
    hold on;plotWetBulbTemp(35+273.15,"b",1);
    xlabel('Dry Bulb Temperature (K)');
    ylabel('Humidity (kg vapor / kg dry air)');
    axis([0+273.15 60+273.15 0 .03]);
    set(gca,...
        'fontsize',16,...
        'box','off',...
        'yaxislocation','right');
end

