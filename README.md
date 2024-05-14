# `psychrometrics` Toolbox for GNU-Octave

[![DOI](https://zenodo.org/badge/565944452.svg)](https://zenodo.org/badge/latestdoi/565944452)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/aumpierre-unb/Psychrometrics-for-GNU-Octave)

![Illustrative graphical output](https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/blob/main/pics/untitled1.png "Example of graphical output")

![Illustrative graphical output](https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/blob/main/pics/untitled2.png "Example of graphical output")

## Installing and Loading `psychrometrics`

```dotnetcli
# e.g. this call installs version 1.0.0
pkg install https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/archive/refs/tags/v1.0.0.tar.gz
pkg load psychrometrics
```

## Citation of `psychrometrics`

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.7325079](https://doi.org/10.5281/zenodo.7325079).
This DOI represents all versions, and will always resolve to the latest one.

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

The thermodynamic state where the smallest amount of energy removed from the gaseous phase produces an incipient condensed phase is called *dew point*. Dew point is characterized by the dew point temperature and the saturation pressure.

### Humidity & Relative Humidity

*Humidity* is the mass ratio of water vapor and dry air. Since both water vapor and dry air are taken as ideal gases, the masses can be replaced by their the partial pressures,

$$
W = 0.621945 {p_{vap} \over {p - p_{vap}}}
$$

or

$$
{1 \over {p - p_{vap}}} = {\displaystyle{1+{W \over 0.621945}} \over p}
$$

where $p$ is the total pressure and $p_{vap}$ is the partial pressure of water vapor. Here, the total pressure is the atmospheric pressure at sea level, 101325 Pa. Analogously, the humidity of saturated air is the saturation humidity,

$$
W_{sat} = 0.621945 {p_{sat} \over {p-p_{sat}}}
$$

*Relative humidity* is the material ratio of water vapor to the water vapor at saturation,

$$
\phi = {p_{vap} \over p_{sat}}
$$

Note that relative humidity is not the ratio of humidity to saturation humidity. This is so because humidities are not fractions.

### Specific Enthalpy & Specific Volume

Consider the adiabatic saturation of humid air with water. The amount of water required is the difference of humidity between the saturation and the humid air. The amount of dry gas is unchanged in the process. That is all about material balances. Taking water at the saturation temperature as reference for enthalpy, the enthalpies per mass of dry air, or *specific enthalpy*, of the inlet humid air, the inlet water and the outlet saturated air are given by

$$
h = c_{dry}\ (T - T_{sat}) + W\ (c_{vap}\ (T - T_{sat}) + \lambda_{sat})
$$

$$
h_{liq} = c_{liq}\ (W_{sat} - w)\ (T_{liq} - T_{sat})
$$

$$
h_{sat} = \lambda_{sat}\ W_{sat}
$$

where $c_{dry}$ and $c_{vap}$ are the heat capacities of the dry gas and of water vapor and $\lambda_{sat}$ is the vaporization latent heat at the saturation temperature. All together, the energy balance gives

$$
{{W - W_{sat}} \over {T - T_{sat}}} = {c \over {-\lambda_{sat} + c_{vap}\ (T_{liq} - T_{sat})}}
$$

where $c$ is the heat capacity of the inlet humid air,

$$
c = c_{dry} + c_{vap}\ (W_{sat} - W)
$$

As the vaporization latent heat is usually much higher than the sensible heat, the variation of humidity in the gaseous phase is closely proportional to its variation in temperature for constant specific enthalpy, producing fairly straight lines in the psychrometric chart.

The volume of the gaseous mixture per mass of dry air, or *specific volume*, is given by

$$
v = {\displaystyle{nRT_{dry} \over p} \over {m_{dry}}} = R_{air}T_{dry} {\displaystyle{1+{W \over 0.621945}} \over p}
$$

At room temperature at atmospheric pressure, humidity is closely proportional to dry bulb temperature for constant specific volume, producing fairly straight lines in the psychrometric chart.

### Dry Bulb Temperature & Wet Bulb Temperature

If the gaseous phase in contact with water is not saturated with water vapor, the system is not at thermodynamic equilibrium. By removing sensible heat from its surroundings, some molecules overcome the vaporization heat and escape from the condensed to the gaseous phase. It happens spontaneously increasing the amount of water vapor in the gaseous phase and decreasing the temperature of the system.

The temperature in the surroundings of the evaporating molecules is the *wet bulb temperature*. This is so because of the construction of the simplest apparatus to indirectly read the air humidity, composed of two bulb thermometers, one in direct contact with the gaseous phase and one in contact with a thin layer of water in contact with the gaseous phase. The temperature of the wet bulb is affected by the evaporation of water from the thin layer to the gaseous phase. The temperature of the gaseous phase is the *dry bulb temperature*, read at the dry bulb.

The spontaneous heat and mass transfer phenomena are given by

$$
q = h\ (T - T_{wet})
$$

$$
N = k\ (p_{wet} - p_{vap})
$$

where $h$ and $k$ are the heat and mass transfer coefficients, $p_{wet}$ is the saturation pressure at the wet bulb temperature and $p_{vap}$ is water vapor pressure of the gaseous phase. In most cases, both pressures are much smaller than the total pressure, so the mass flux can be approximate to

$$
N = k^*\ (W_{wet} - W)
$$

where $k^*$ is a mass transfer coefficient. The energy removed from water adjacent to the wet bulb is used to evaporate part of that water

$$
q = N\ \lambda_{wet}
$$

where $\lambda_{wet}$ is the heat of vaporization at the wet bulb temperature. Combining mass and energy transfer phenomena, one has

$$
{{W - W_{wet}} \over {T - T_{wet}}} = -{h \over {\lambda_{wet}\ k^*}}
$$

Therefore, the variation of humidity in the gaseous phase is closely proportional to its variation in temperature, producing fairly straight lines in the psychrometric chart for constant wet bulb temperature.

### Empirical Equations

Equations used in `psychrometrics` toolbox come from the first chapter of the *2017 ASHRAE Handbook Fundamentals Systems - International Metric System*, published by the American Society of Heating, Refrigerating and Air-Conditioning Engineers.

For ice in the range -100 °C to 0 °C, the water vapor pressure in equilibrium with pure ice is given by

$$
\ln p_{sat}^* = {C_1 \over T} + C_2 + C_3\ T + C_4\ T^2 + C_5\ T^3 + C_6\ T^4 + C_7 \ln T
$$

and for water in the range 0 °C to 200 °C, the water vapor pressure in equilibrium with pure water is given by

$$
\ln p_{sat}^* = {C_8 \over T} + C_9 + C_{10}\ T + C_{11}\ T^2 + C_{12}\ T^3 + C_{13} \ln T
$$

where $p^*_{sat}$ is given in Pa and dry bulb temperature $T$, in K.

As the saturation of air in ice and water is negligible, the water vapor pressure over pure ice or water is almost the same as the saturation pressure over ice or water when there is air in the gaseous phase.

The specific volume and the specific enthalpy (volume and enthalpy of the gaseous phase per unit of mass of dry air) are given by

$$
v = {{0.287042\ (t_{dry} + 273.15)\ (1 + 1.607858\ W)} \over p}
$$

$$
h = 1.006\ t_{dry} + W\ (2501 + 1.86\ t_{dry})
$$

with $v$ given in m<sup>3</sup>/kg of dry air, $h$ in kJ/kg, dry bulb temperature $t_{dry}$ in °C, $W$ in kg/kg<sub>dry</sub>, and total pressure $p$ in kPa.

Dew point is given by

$$
t_{dew} = C_{14} + C_{15}\ \alpha + C_{16}\ \alpha^2 + C_{17}\ \alpha^3 + C_{18}\ p_{vap}^{0.1984}
$$

where $\alpha = ln\ p_{vap}$, with water vapor pressure $p_{vap}$ given in kPa and dew point temperature $t_{dew}$ in °C. The parameters for the equations used in `psychrometrics` toolbox are

$$
C=
\begin{bmatrix}
    \begin{align*}
        -5&.6745359 \times 10^3 \\
        6&.3925247 \\
       -9&.6778430 \times 10^{-3} \\
        6&.2215701 \times 10^{-7} \\
        2&.0747825 \times 10^{-9} \\
       -9&.4840240 \times 10^{-13} \\
        4&.1635019 \\
       -5&.8002206 \times 10^3 \\
        1&.3914993 \\
       -4&.8640239 \times 10^{-2} \\
        4&.1764768 \times 10^{-5} \\
       -1&.4452093 \times 10^{-8} \\
        6&.5459673 \\
        6&.54 \\
       14&.526 \\
        0&.7389 \\
        0&.09486 \\
        0&.4569 \\
    \end{align*}
\end{bmatrix}
$$

## The `psychrometrics` Toolbox

`psychrometrics` provides the following functions:

- `psychro`
- `humidity`
- `satPress`
- `enthalpy`
- `volume`
- `adiabSat`

All inputs and outputs of all functions are given in units of the International System.

### `psychro`

`psychro` computes

- the dry bulb temperature Tdry (in K),
- the wet bulb temperature Twet (in K),
- the dew point temperature Tdew (in K),
- the adiabatic saturation temperature Tadiab (in K),
- the humidit W (in kg/kg of dry air),
- the saturation humidity Wsat (in kg/kg of dry air),
- the saturation humidity at the wet bulb temperature Wsatwet (in kg/kg of dry air),
- the adiabatic saturation humidity Wadiab (in kg/kg of dry air),
- the specific enthalpy h (in J/kg of dry air),
- the specific volume v (in cu. m/kg of dry air),
- the the relative humidity phi,
- the water vapor pressure pw (in Pa),
- the water saturation pressure psat (in Pa),
- the saturation pressure at the wet bulb temperature psatwet (in Pa) and
- the density rho (in kg/cu. m)

given any two parameters among

- the dry bulb temperature Tdry (in K),
- the wet bulb temperature Twet (in K),
- the dew point temperature Tdew (in K),
- the humidit W (in kg/kg of dry air),
- the specific enthalpy h (in J/kg of dry air),
- the specific volume v (in cu. m/kg of dry air) and
- the the relative humidity phi,
- except the combination of water vapor pressure and
- dew point temperature, which are not independent.

except for the combination of water vapor pressure and dew point temperature, which are not mutually independent.

If *fig* = *true* is given, a schematic psychrometric chart is plotted as a graphical representation of the solution.

**Syntax:**

```dotnetcli
[~,~,~,~,W,~,~,~,h,v]=psychro(Tdry=300,Twet=295)
[~,~,~,Tadiab,~,~,Wsatwet,Wadiab]=psychro(Tdry=298,:,:,:,:,:,phi=0.50,true)
[Tdry,Twet,Tdew,~,~,~,~,~,~,~,phi,pw]=psychro(:,:,:,:,h=40e3,v=0.85)
[Tdry,~,~,~,~,~,~,~,~,~,~,~,psat,psatwet,rho]=psychro(:,:,:,:,h=55e3,v=0.87,:,true)
```

**Examples:**

Compute the dry bulb temperature, the wet bulb temperature, the adiabatic saturation temperature, the humidity, the saturation humidity, the saturation humidity at wet bulb temperature, the adiabatic saturation humidity, the specific enthalpy, the specific volume, the relative humidity, the water vapor pressure, the saturation pressure, the saturation pressure at wet bulb temperature and the density given the dew point temperature is 22 °C and the relative humidity is 29 %:

```dotnetcli
[Tdry,Twet,Tdew,Tadiab,W,Wsat,Wsatwet,Wadiab,h,v,phi,pw,psat,psatwet,rho]=...
psychro(:,:,Tdew=22+273.15,:,:,:,phi=0.29) # parameters and returns in SI units
```

8.5 cubic meters of humid air at dry bulb temperature of 293 K and wet bulb temperature of 288 K is subjected to two cycles of heating to 323 K followed by adiabatic saturation. Compute the energy and water vapor demands. Assume the amount of dry air is constant.

```dotnetcli
# All parameters and returns in SI units
# The initial condition is
[~,~,~,~,W1,~,~,~,h1,v1]=psychro(Tdry1=293,Twet1=288,:,:,:,:,:,true)

# The thermodynamic state after the first heating is
[~,~,~,~,~,~,~,~,h2,v2]=psychro(Tdry2=323,:,:,W2=W1,:,:,:,true)

# The thermodynamic state the after first adiabatic saturation is
[Tdry3,W3]=adiabSat(h3=h2)
[~,~,~,~,~,~,~,~,~,v3]=psychro(Tdry3,:,:,W3)

# The thermodynamic state after the second heating is
[~,~,~,~,~,~,~,~,h4,v4]=psychro(Tdry4=323,:,:,W4=W3,:,:,:,true)

# The thermodynamic state the after second adiabatic saturation is
[Tdry5,W5]=adiabSat(h5=h4)
[~,~,~,~,~,~,~,~,~,v5]=psychro(Tdry5,:,:,W5)

# The energy and water vapor demands are
(h5-h1)*(8.5/v1) # demand of energy
(W5-W1)*(8.5/v1) # demand of water vapor
```

### `humidity`

`humidity` computes
the humidity of humid air in given the water vapor pressure and the total pressure. By default, total pressure is assumed to be the atmospheric pressure at sea level.

**Syntax:**

```dotnetcli
W=humidity(pw[,p])
```

**Examples:**

Compute the humidity of humid air at atmospheric pressure given water vapor pressure is 1 kPa at 1 atm total pressure.

```dotnetcli
W=humidity(pw=1e3) # parameters and returns in SI units
```

### `satPress`

`satPress` computes the saturation pressure of humid air given the dry bulb temperature.

**Syntax:**

```dotnetcli
psat=satPress(Tdry)
```

**Examples:**

Compute the saturation pressure given the dry bulb temperature is 25 °C.

```dotnetcli
psat=satPress(Tdry=25+273.15) # parameters and returns in SI units
```

### `enthalpy`

`enthalpy` computes the specific enthalpy of humid air given the dry bulb temperature and the humidity in.

**Syntax:**

```dotnetcli
h=enthalpy(Tdry,W)
```

**Examples:**

Compute the specific enthalpy given the dry bulb temperature is 25 °C and the humidity is 7 g/kg of dry air.

```dotnetcli
h=enthalpy(Tdry=25+273.15,W=7e-3) # parameters and returns in SI units
```

### `volume`

`volume` computes computes the specific volume of humid air given  the dry bulb temperature, the humidity in and the total pressure. By default, total pressure is assumed to be the atmospheric pressure at sea level.

**Syntax:**

```dotnetcli
v=volume(Tdry,W[,p])
```

**Examples:**

Compute the specific volume given the dry bulb temperature is 25 °C and the humidity is 7 g/kg of dry air at 1 atm total pressure.

```dotnetcli
v=volume(Tdry=25+273.15,W=7e-3) # parameters and returns in SI units
```

### `adiabSat`

`adiabSat` computes the the adiabatic saturation temperature and the adiabatic saturation humidity given the specific enthalpy. If *fig* = *true* is given, a schematic psychrometric chart is plotted as a graphical representation of the solution.

**Syntax:**

```dotnetcli
[Tadiab,Wadiab]=adiabSat(h[,fig])
```

**Examples:**

Compute the the adiabatic saturation temperature and the adiabatic saturation humidity given the specific enthalpy is 82.4 kJ/kg of dry air and plot a graphical representation of the answer in a schematic psychrometric chart.

```dotnetcli
[Tadiab,Wadiab]=adiabSat(h=82.4e3,true) # parameters and returns in SI units
```

### Reference

The theory and the adjusted equations used in this package were taken from the first chapter of the *2017 ASHRAE Handbook Fundamentals Systems - International Metric System*, published by the American Society of Heating, Refrigerating and Air-Conditioning Engineers.

### Acknowledgements

The author of `psychrometrics` package acknowledges Professor Brent Stephens, Ph.D. from the Illinois Institute of Technology for kindly suggesting the source reference for equations used for this package.

### See Also

[McCabe-Thiele-for-GNU-Octave](https://github.com/aumpierre-unb/McCabe-Thiele-for-GNU-Octave),
[Ponchon-Savarit-for-GNU-Octave](https://github.com/aumpierre-unb/Ponchon-Savarit-for-GNU-Octave),
[Internal-Fluid-Flow-for-GNU-Octave](https://github.com/aumpierre-unb/Internal-Fluid-Flow-for-GNU-Octave).

Copyright &copy; 2022 2023 Alexandre Umpierre

email: aumpierre@gmail.com
