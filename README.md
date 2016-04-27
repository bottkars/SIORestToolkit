# SIORestToolkit
Powershell Toolkit for EMC ScaleIO using the Rest  API Gateway

The SIOrestToolkit utilizes the ScaleIO API 2.0 
It requires ScaleIO 2.0 Systems installed.

The Modulkes are loaded via Import-Module SIORestToolKit
The Module sudirectories are based on the role of functions , eg types, actions, errors.

in order to runs the command, you need to unrestrict executiopolicy.
open a powershell as admin and run
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

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
# Commands
To get a List of currently awailable commands, type
```Powershell
Get-Command -Module SIORestToolkit
```
#Examples
TO create a new Volume, use the New-SIOVolume command. It requires a StoragePoolID as Input Parameter  
To get a Storage Pool ID use the Get-SIOStoragePoolList command
```Powershell
(Get-SIOstoragePoolList | where storagePoolName -match "geek").storagePoolId
```
This example will retrieve the Pool ID for the Pool that matches the Name "geek"   
to create a new Volume in the Pool, use
```Powershell
New-SIOVolume -storagePoolID (Get-SIOstoragePoolList | where storagePoolName -match "geek").storagePoolId
````
or 
```Powershell
New-SIOVolume -storagePoolID [storagePoolid]
```

using -verbose switch will display the Json Body of the Request    
```Powershell
New-SIOVolume -storagePoolID (Get-SIOstoragePoolList | where storagePoolName -match "geek").storagePoolId -Verbose
VERBOSE: {
    "volumeSizeInKb":  "4194304",
    "storagePoolId":  "76733fa700000000",
    "name":  null,
    "volumeType":  "ThickProvisioned"
}
VERBOSE: POST https://192.168.2.193/api/types/Volume/instances with -1-byte payload
VERBOSE: received -1-byte response of content type application/json;charset=UTF-8
VERBOSE: GET https://192.168.2.193/api/instances/Volume::c10bdced00000008 with 0-byte payload
VERBOSE: received -1-byte response of content type application/json;charset=UTF-8


VolumeName              :
VolumeID                : c10bdced00000008
creationTime            : 1460714992
isObfuscated            : False
volumeType              : ThickProvisioned
consistencyGroupId      :
vtreeId                 : 1f12c57100000008
ancestorVolumeId        :
useRmcache              : True
sizeInKb                : 8388608
storagePoolId           : 76733fa700000000
mappedSdcInfo           :
mappingToAllSdcsEnabled : False

```
