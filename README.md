# `psychrometrics` Toolbox for GNU-Octave (*under construction*)

<!-- [![DOI](https://zenodo.org/badge/509427410.svg)](https://zenodo.org/badge/latestdoi/509427410)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/aumpierre-unb/Psychrometrics-for-GNU-Octave) -->

<!-- ![Illustrative graphical output](https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/blob/main/pics/chart.png "Example of graphical output") -->

## Installing and Loading `psychrometrics`

<!-- ```dotnetcli
# use this call to install version 0.1.0, or modify the command line for match the version
pkg install https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/archive/refs/tags/v0.1.0.tar.gz
pkg update psychrometrics
pkg load psychrometrics
``` -->

<!-- ## Citation of `psychrometrics`

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.6960263](https://doi.org/10.5281/zenodo.xxxxx).

This DOI represents all versions, and will always resolve to the latest one.

To cite the last released version, please check
https://zenodo.org/account/settings/github/repository/aumpierre-unb/Psychrometrics-for-GNU-Octave. -->

---

The following is a very short introduction to psychrometrics and to the `psychrometrics` toolbox for GNU Octave. This text is divided in two main sections: The Theory and The `psychrometrics` Toolbox.

## The Theory

### Psychrometrics

Psychrometrics is the field of physics concerned with the thermodynamic properties of a mixture of a condensable vapor and a non condensable gas. The most usual situation in engineering is the mixture of water vapor in the atmospheric air at atmospheric pressure.

A psychrometric chart is a two dimensional diagram used for engineers to predict the thermodynamical state of humid air. In most cases, engineers are concerned with the properties of mixtures of water vapor and atmospheric air at atmospheric pressure. The prediction of the properties of such systems are mandatory for a series of industrial processes related to humidification and dehumidification as well as with air-conditioning processes.

The basic readings from a psychrometric chart are the thermodynamic temperature and the humidity. Humidity is the mass ratio of water vapor to dry air.

Alongside with thermochemical properties of water vapor and dry air, the material and energy balances allow to calculate the specific enthalpy and the specific volume of the system using some equation of state. The ideal gas equations of state is usually used since water vapor and dry air present negligible deviation from ideality at room temperature.

Also, alongside with mass and energy transfer coefficients of water vapor, the combined mass and energy transfer phenomena allow to calculate the temperature of a thin layer of liquid water providing water vapor to the gaseous mixture. This temperature is refereed to as wet bulb temperature, while the thermodynamic temperature is refereed to as dry bulb temperature.

Most psychrometric charts show sets of lines of constant specific volume, constant specific enthalpy and constant wet bulb temperature. Set all together, they produce a fairly complete chart of the thermodynamic state of humid air.

### Saturation & Dew Point

Consider a constant pressure control volume filled with humid air only. As temperature decreases, all particles in the system lose energy. Eventually, some particles of water will lose energy ate the point they condensate. At this point, the gaseous mixture contains the maximum possible amount of water particles, it is said to be saturated. In psychrometrics, *saturation* is the condition where the maximum amount of water vapor is in the gaseous phase.

Once pressure is an indirect measure of the number of particles in the system, the amount of particles in the gaseous phase is indirectly refereed to as saturation pressure.

The thermodynamic state where the smallest amount of energy removed from the gaseous phase produces an incipient condensed phase is called *dew point*. Dew point is characterized by the dew temperature and the saturation pressure.

### Humidity & Relative Humidity

*Humidity* is the mass ratio of water vapor and dry air. Since both water vapor and dry air are taken as ideal gases, the masses can be replaced by their the partial pressures,

$$
W = 0.621945 {p_v \over {p - p_v}}
$$

where $p$ is the total pressure and $p_v$ is the partial pressure of water vapor. Here, the total pressure is the atmospheric pressure at sea level, 101325 Pa. Analogously, the humidity of saturated air is the saturation humidity,

$$
W_{sat} = 0.621945 {p_{sat} \over {p-p_{sat}}}
$$

*Relative humidity* is the material ratio of water vapor to the water vapor at saturation,

$$
\phi = {p_v \over p_{sat}}
$$

Note that relative humidity is not the ratio of humidity to saturation humidity. This is so because humidities are not fractions.

### Specific Enthalpy & Specific Volume

Consider the adiabatic humidification of humid air with water. The amount of water is the difference of humidity between the outlet and the inlet gaseous phases. The amount of dry gas is unchanged. That is all about material balances. Taking water at the outlet temperature as reference for enthalpy, the enthalpies per mass of dry air, or *specific enthalpy*, of the three streams are:

$$
h_1 = c_g (T_1 - T_3) + H_1 (c_v (T_1 - T_3) + \lambda_3)
$$

$$
h_2 = c_v (H_3 - H_1) (T_2 - T_3)
$$

$$
h_3 = \lambda_3 H_3
$$

where $c_g$ and $c_v$ are the heat capacities of the dry gas and of water and $\lambda_3$ is the vaporization heat at the outlet temperature. All together, the energy balance gives

$$
{{H_1 - H_3} \over {T_1 - T_3}} = {c_1 \over {-\lambda_3 + c_v (T_2 - T_3)}}
$$

where $c_1$ is the heat capacity of the inlet humid air,

$$
c_1 = c_g + c_v (H_3 - H_1)
$$

As the vaporization heat is usually much higher than the sensible heat, the variation of humidity in the gaseous phase is fairly proportional to its variation in temperature, producing a fairly straight line in a plot of humidity and temperature.

### Dry Bulb Temperature & Wet Bulb Temperature

If the gaseous phase in contact with water is not saturated with water vapor, the system is not at thermodynamic equilibrium. By removing sensible heat from its surroundings, some molecules overcome the vaporization heat and escape from the condensed to the gaseous phase. It happens spontaneously increasing the amount of water vapor in the gaseous phase and decreasing the temperature of the system.

The temperature in the surroundings of the evaporating molecules is the *wet bulb temperature*. This is so because of the construction of the simplest apparatus to indirectly read the air humidity, composed of two bulb thermometers, one in direct contact with the gaseous phase and one in contact with a thin layer of water in contact with the gaseous phase. The temperature of the wet bulb is affected by the evaporation of water from the thin layer to the gaseous phase. The temperature of the gaseous phase is the *dry bulb temperature*, read at the dry bulb.

The spontaneous heat and mass transfer phenomena are given by

$$
q = h (T - T_{wet})
$$

$$
N = k (p_{wet} - p_v)
$$

where $h$ and $k_G$ are the heat and mass transfer coefficients, $p_{wet}$ is the saturation pressure at the wet bulb temperature and $p_v$ is water vapor pressure of the gaseous phase. In most cases, both pressures are much smaller than the total pressure, so the mass flux can be approximate to

$$
N = k^* (H_{wet} - H)
$$

where $k^*$ is a mass transfer coefficient. The energy removed from water adjacent to the wet bulb is used to evaporate part of that water

$$
q = N \lambda_{wet}
$$

where $\lambda_{wet}$ is the heat of vaporization at the wet bulb temperature. Combining mass and energy transfer phenomena, one has

$$
{{H - H_{wet}} \over {T - T_{wet}}} = -{h \over {\lambda_{wet} k^*}}
$$

Therefore, the variation of humidity in the gaseous phase is fairly proportional to its variation in temperature, producing a fairly straight line in a plot of humidity and temperature.

### Empirical Equations

Equations used in `psychrometrics` toolbox come from the first chapter of the *2017 ASHRAE Handbook Fundamentals Systems - International Metric System*, published by the American Society of Heating, Refrigerating and Air-Conditioning Engineers.

For ice in the range -100 °C to 0 °C, the water vapor pressure in equilibrium with pure ice is given by

$$
\ln {p^*_{sat}} = {C_1 \over T} + C_2 + C_3T + C_4T^2 + C_5T^3 + C_6T^4 + C_7 \ln T
$$

and for water in the range 0 °C to 200 °C, the water vapor pressure in equilibrium with pure water is given by

$$
\ln {p^*_{sat}} = {C_8 \over T} + C_9 + C_{10}T + C_{11}T^2 + C_{12}T^3 + C_{13} \ln T
$$

where $p^*_{sat}$ is given in Pa and *T*, in K.

As the saturation of air in ice and water is negligible, the water vapor pressure over pure ice or water is almost the same as the saturation pressure over ice or water.

The specific volume and the specific enthalpy (volume and enthalpy of the gaseous phase per unit of mass of dry air) are given by

$$
v = {{0.287042 (t + 273.15) (1 + 1.607858 W)} \over p}
$$

$$
h = 1.006 t + W (2501 + 1.86 t)
$$

with $v$ given in m<sup>3</sup>/kg of dry air, $h$ in kJ/kg, $t$ in °C, and $p$ in kPa.

## The `psychrometrics` Toolbox

`psychrometrics` provides the following functions:

- `psychro`

### `psychro`

`psychro` computes the dry bulb temperature, the wet bulb temperature, the dew point temperature, the humidity, the saturation humidity, the saturation humidity at wet bulb temperature, the specific enthalpy, the specific volume, the relative humidity, the water vapor pressure, the saturation pressure, the saturation pressure at wet bulb temperature and the density given two of dry bulb temperature, wet bulb temperature, dew point temperature, humidity, specific enthalpy, specific volume or relative humidity. If a different number of inputs is given, execution will be aborted.

**Syntax:**

```dotnetcli
# e.g.
# given Tdry and W
# unknowns must be indicated by default value syntax
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=psychro(Tdry:,:,W,:,:,:)
```

**Examples:**

Compute the dry bulb temperature, the wet bulb temperature, the dew point temperature, the humidity, the saturation humidity, the saturation humidity at wet bulb temperature, the specific enthalpy, the specific volume, the relative humidity, the water vapor pressure, the saturation pressure, the saturation pressure at wet bulb temperature and the density given
the dew temperature $T_{dew}$ = 12 °C and
the relative humidity $\phi$ = 29 %:

```dotnetcli
Tdew=12+273.15;
phi=.29;
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,Tdew,:,:,:,phi)
```

### Acknowledgements

I would like to acknowledge Professor Brent Stephens, Ph.D. from the Illinois Institute of Technology for kindly suggesting the source reference for equations used for `psychrometrics` toolbox.

### See Also

[McCabe-Thiele-for-GNU-Octave](https://github.com/aumpierre-unb/McCabe-Thiele-for-GNU-Octave),
[Ponchon-Savarit-for-GNU-Octave](https://github.com/aumpierre-unb/Ponchon-Savarit-for-GNU-Octave),
[Internal-Fluid-Flow-for-GNU-Octave](https://github.com/aumpierre-unb/Internal-Fluid-Flow-for-GNU-Octave).

Copyright &copy; 2022 Alexandre Umpierre

email: aumpierre@gmail.com
