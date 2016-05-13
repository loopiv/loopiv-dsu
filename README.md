# dsu

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with dsu](#setup)
    * [What dsu affects](#what-dsu-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dsu](#beginning-with-dsu)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Installs the latest Dell System Update (DSU) for PowerEdge systems.  Also,
configures email alerts via a custom script for all events.

Compatible with EL6 & 7 and Puppet 3.8.x.  Installs the 'dsu' command and
OpenManage Server Administrator (OMSA).

## Module Description

Configures the DSU yum repositories, installs dsu and OMSA, manages the
services, and configures email alerts.

## Setup

### What dsu affects

* DSU yum repositories
* OMSA services
* OMSA alert hourly cron job
* /etc/aliases
* Warning: Only works on EL6 & EL7.  The modules tests for PowerEdge systems,
  but not OS distro or version.

## Usage

* Include the module or use hiera with the %{::operatingsystemmajrelease} fact.

## Reference

* Uses the productname fact to determine whether the system is a PowerEdge.
* puppet-stdlibs is needed to add a mail alias to /etc/aliases.  It currently
  points to root.
* Quite a few relationships are defined and could probably be done better with
  ordering.

## Limitations

* Dell PowerEdge systems running EL6 and 7 only.  Tested on CentOS 6 and 7.
* Puppet < 4.x

