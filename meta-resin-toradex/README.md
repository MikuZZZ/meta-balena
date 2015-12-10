# Resin.io layer for meta-toradex supported boards

## Description
This repository enables building resin.io for chosen meta-toradex machines.

## Supported machines
* apalis-imx6
* colibri-imx6

## Layer dependencies

This layer depends on:

* URI: ssh://git@bitbucket.org/rulemotion/meta-resin
    * layer: meta-resin-common
    * branch: master
    * revision: HEAD
* URI: git://github.org/Freescale/meta-fsl-arm
    * branch: fido
    * revision: 270599a407a36f1ff0cdbe5fcfc03f1a3a61789c
* URI: http://git.toradex.com/cgit/meta-toradex.git/
    * branch: V2.5
    * revision: 4e86d3bdd18c649197f73e4a7f99a2bfcf7899b8