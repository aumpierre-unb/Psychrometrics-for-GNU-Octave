# `psychrometrics` Toolbox for GNU-Octave

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

## Citation of `psychrometrics`

You can cite all versions (both released and pre-released), by using
[DOI 105281/zenodo.6960263](https://doi.org/10.5281/zenodo.xxxxx).

This DOI represents all versions, and will always resolve to the latest one.

To cite the last released version, please check
https://zenodo.org/account/settings/github/repository/aumpierre-unb/Psychrometrics-for-GNU-Octave.

---

The following is a very short introduction to psychrometrics and to the `psychrometrics` toolbox for GNU Octave.

The psychrometric chart is a two dimensional diagram used for engineers to characterize the thermodynamical state of a gaseous mixture of air and water vapor.
That is a mandatory task for a series of processes related to umidification and desumidification. These unit operations are the basis of air-conditioning.

The basic readings from a psychrometric chart are the thermodynamic temperature and the humidity, the mass ratio of water vapor to dry air.
Alongside with the heat of vaporization of water and the heat capacities of water vapor and dry air,
material and energy balances allow to calculate the enthalpy and volume of the mixture with some equation of state.
In most cases, water vapor and dry air are assumed to be ideal gases at room temparature.
Also, alongside with material and energy diffusivities of water vapor, the combined mass and energy transport phenomena allow to calculate
the temperature of a thin layer of liquid water providing water vapor to the gaseous mixture.
This temperature is refered to as wet bulb temperature, while the thermodynamic temmerature is refered to as dry bulb temperature.

Most psychrometric charts show families of lines of constant specific volume, specific enthalpy and wet bulb temprature.
All toghether they allow a thorough characterization of the themodynamic state of a misture of water vapor and dry air.

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

### Dry Bulb Temperaure & Wet Bulb Temperaure

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
