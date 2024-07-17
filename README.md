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
