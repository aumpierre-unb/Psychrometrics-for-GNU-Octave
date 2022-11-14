# `psychrometrics` Toolbox for GNU-Octave (under construction)

<!-- [![DOI](https://zenodo.org/badge/509427410.svg)](https://zenodo.org/badge/latestdoi/509427410)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/aumpierre-unb/Psychrometrics-for-GNU-Octave) -->

![Illustrative graphical output](https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/blob/main/pics/chart.png "Example of graphical output")

## Installing and Loading `psychrometrics`

```dotnetcli
# use this call to install version 0.1.0, or modify the command line for match the version
pkg install https://github.com/aumpierre-unb/Psychrometrics-for-GNU-Octave/archive/refs/tags/v0.1.0.tar.gz
pkg update psychrometrics
pkg load psychrometrics
```

<!-- ## Citation of `psychrometrics`

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.6960263](https://doi.org/10.5281/zenodo.xxxxx).

This DOI represents all versions, and will always resolve to the latest one.

To cite the last released version, please check
https://zenodo.org/account/settings/github/repository/aumpierre-unb/Psychrometrics-for-GNU-Octave. -->

---

The following is a very short introduction to psychrometrics and to the `psychrometrics` toolbox for GNU Octave.

Psychrometrics (or psychrometry) is the field of physics concerned with the thermodynamic properties of a mixture of a condensable vapor and a non condensable gas. The most usual situation in engineering is the mixture of water vapor in the atmospheric air at atmospheric pressure.

A psychrometric chart is a two dimensional diagram used for engineers to predict the thermodynamical state of humid air. In most cases, engineers are concerned with the properties of mixtures of water vapor and atmospheric air at atmospheric pressure. The prediction of the properties of such systems are mandatory for a series of industrial processes related to humidification and dehumidification as well as with air-conditioning processes.

The basic readings from a psychrometric chart are the thermodynamic temperature and the humidity. Humidity is the mass ratio of water vapor to dry air.

Alongside with thermochemical properties of water vapor and dry air, the material and energy balances allow to calculate the specific enthalpy and the specific volume of the system using some equation of state. The ideal gas equations of state is usually used since water vapor and dry air present negligible deviation from ideality at room temperature.

Also, alongside with material diffusivity and energy diffusivity of water vapor, the combined mass and energy transport phenomena allow to calculate the temperature of a thin layer of liquid water providing water vapor to the gaseous mixture. This temperature is refereed to as wet bulb temperature, while the thermodynamic temperature is refereed to as dry bulb temperature.

Most psychrometric charts show sets of lines of constant specific volume, constant specific enthalpy and constant wet bulb temperature. Set all together, they produce a fairly complete chart of the thermodynamic state of humid air.

This text is divided in two main sections: The Theory and The `psychrometrics` Toolbox.

## The Theory

<!-- ### Vapor Pressure & Humidity

xxxxxxxxxxxxx

$$
{\rho v_2^2 \over 2} + \rho g z_2 + p_2 =
{\rho v_1^2 \over 2} + \rho g z_1 + p_1
$$

### Saturation & Dew Temperature

xxxxxxxxx

$$
h=f{v^2 \over 2g} {L \over D}
$$

### Dry Bulb Temperature & Wet Bulb Temperature

xxxxxxxxxx

$$
f={64 \over Re}
$$

## The `psychrometrics` Toolbox

`psychrometrics` provides the following functions:

- `psychro`

### `psychro`

`psychro` computes the Darcy friction factor *f* given the relative roughness $\varepsilon$ and the Reynolds number *Re*. If given *Re* < 2,500, then flow is assumed to be laminar and *f* is computed using of the Poiseuille condition. Otherwise, flow is assumed to be turbulent and *f* is computed using the Colebrook-White equation.

**Syntax:**

```dotnetcli
[Tdry,Twet,Tdew,W,Wsat,Wsatwet,h,v,phi,pw,psat,psatwet,rho]=psychro([Tdry][,Twet][,Tdew][,W][,h][,v][,phi])
```

**Examples:**

Compute the Darcy friction factor *f* given
the Reynolds number *Re* = 120,000 and
the relative roughness $\varepsilon$ = 0.001:

```dotnetcli
Re=1.2e5;eps=1e-3;
f=psychro(Re,eps)
```

Compute *f* and plot a schematic Moody diagram:

```dotnetcli
f=psychro(1.2e5,1e-3,true)
```

Compute the Darcy friction factor *f* given
the Reynolds number *Re* = 120,000
for a smooth tube and plot
a schematic Moody diagram
with the solution:

```dotnetcli
f=psychro(1.2e5,:,true)
```

### See Also -->

[McCabe-Thiele-for-GNU-Octave](https://github.com/aumpierre-unb/McCabe-Thiele-for-GNU-Octave),
[Ponchon-Savarit-for-GNU-Octave](https://github.com/aumpierre-unb/Ponchon-Savarit-for-GNU-Octave).
[Internal-Fluid-Flow-for-GNU-Octave](https://github.com/aumpierre-unb/Internal-Fluid-Flow-for-GNU-Octave).

Copyright &copy; 2022 Alexandre Umpierre

email: aumpierre@gmail.com
