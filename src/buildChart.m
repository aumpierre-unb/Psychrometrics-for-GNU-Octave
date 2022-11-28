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

function buildChart()
    # Syntax:
    #
    # buildChart()
    #
    # buildChart computes data for
    #  a schematic psychrometric chart.
    # buildChart is an internal function of
    #  the psychrometrics toolbox for GNU Octave.
    u=[];
    [T,W]=buildVolume(.78);u=[u T W];
    [T,W]=buildVolume(.80);u=[u T W];
    [T,W]=buildVolume(.82);u=[u T W];
    [T,W]=buildVolume(.84);u=[u T W];
    [T,W]=buildVolume(.86);u=[u T W];
    [T,W]=buildVolume(.88);u=[u T W];
    [T,W]=buildVolume(.90);u=[u T W];
    [T,W]=buildVolume(.92);u=[u T W];
    [T,W]=buildVolume(.94);u=[u T W];
    [T,W]=buildVolume(.96);u=[u T W];
    [T,W]=buildVolume(.98);u=[u T W]

    u=[];
    [T,W]=buildWetBulbTemp(00+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(05+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(10+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(15+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(20+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(25+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(30+273.15);u=[u T W];
    [T,W]=buildWetBulbTemp(35+273.15);u=[u T W]

    u=[];
    [T,W]=buildEnthalpy(10e3);u=[u T W];
    [T,W]=buildEnthalpy(20e3);u=[u T W];
    [T,W]=buildEnthalpy(30e3);u=[u T W];
    [T,W]=buildEnthalpy(40e3);u=[u T W];
    [T,W]=buildEnthalpy(50e3);u=[u T W];
    [T,W]=buildEnthalpy(60e3);u=[u T W];
    [T,W]=buildEnthalpy(70e3);u=[u T W];
    [T,W]=buildEnthalpy(80e3);u=[u T W];
    [T,W]=buildEnthalpy(90e3);u=[u T W];
    [T,W]=buildEnthalpy(10e4);u=[u T W];
    [T,W]=buildEnthalpy(11e4);u=[u T W];
    [T,W]=buildEnthalpy(12e4);u=[u T W];
    [T,W]=buildEnthalpy(13e4);u=[u T W]

    u=[];
    [T,W]=buildHumidity(1.);u=[u T W];
    [T,W]=buildHumidity(.8);u=[u T W];
    [T,W]=buildHumidity(.6);u=[u T W];
    [T,W]=buildHumidity(.4);u=[u T W]

    u=[];
    [T,W]=buildHumidity(.30);u=[u T W];
    [T,W]=buildHumidity(.25);u=[u T W];
    [T,W]=buildHumidity(.20);u=[u T W];
    [T,W]=buildHumidity(.15);u=[u T W];
    [T,W]=buildHumidity(.10);u=[u T W];
    [T,W]=buildHumidity(.05);u=[u T W]

end

