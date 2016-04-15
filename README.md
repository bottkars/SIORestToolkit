# SIORestToolkit
Powershell Toolkit for EMC ScaleIO using the Rest  API Gateway

The SIOrestToolkit utilizes the ScaleIO API 2.0 
It requires ScaleIO 2.0 Systems installed.

The Modulkes are loaded via Import-Module SIORestToolKit
The Module sudirectories are based on the role of functions , eg types, actions, errors.

To start with the Modules, connect to a ScaleIO Gateway with
```Powershell
Connect-SIOGateway -GatewayIP 192.168.2.193 -user admin -password Password123!
Successfully connected to ScaleIO https://192.168.2.193:443


Systemid                  : 511ed7166c39d314
SystemName                : ScaleIO@geekweek
systemVersionName         : EMC ScaleIO Version: R2_0.5014.0
installIdswid             :
daysInstalled             : 1
maxCapacityInGb           : Unlimited
capacityTimeLeftInDays    : Unlimited
enterpriseFeaturesEnabled : True
isInitialLicense          : True
defaultIsVolumeObfuscated : False
restrictedSdcModeEnabled  : False
```
The command will create a Auth Token with the ScaleIO Gateway and stores that as a Global Authenticationblock for the current PSSession
The System will Report the Gateway version and System Cofiguration at first.
To get a List of currently awailable commands, type
```Powershell
Get-Command -Module SIORestToolkit
```

