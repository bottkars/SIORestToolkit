# SIORestToolkit
Powershell Toolkit for EMC ScaleIO using the Rest  API Gateway

The SIOrestToolkit utilizes the ScaleIO API 2.0 
It requires ScaleIO 2.0 Systems installed.

### aditional info   
please visit our slack channel for general discussion on scaleio / rest  
https://codecommunity.slack.com/messages/scaleio_rest/

###requirements
in order to run the commands, you need to unrestrict executionpolicy.
also, make sure to unblock the zipfile if you download the modules as zip and not via git ( unblock-file or right click in explorer )
open a powershell as admin and run
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

## installation  
The Modulkes are loaded via Import-Module SIORestToolKit
The Module sudirectories are based on the role of functions , eg types, actions, errors.

use this Automatic downloader to install SIORestToolKit:
```Powershell
$Uri="https://gist.githubusercontent.com/bottkars/b3f4556abbaf1f5f3b402ab6b87c9d77/raw/Install-SIORestToolkit.ps1"
$DownloadLocation = "$Env:USERPROFILE\Downloads"
$File = Split-Path -Leaf $Uri
$OutFile = Join-Path $DownloadLocation $File
Invoke-WebRequest -Uri $Uri -OutFile $OutFile
Unblock-File -Path $Outfile
Set-Location $DownloadLocation
.\install-SIORestToolkit.ps1 -Installpath [replacewithyourdestination]
```
## alternative installation  
if not using the Downloader, i Recommend cloning into the modules using and do regular pulls for update rather tan downloading the zip. this also eliminates the need for unblocking the zip archive !!! )

consider https://desktop.github.com/ for windows

import the modules
```powershell
import-module \path-to-moduledir\SIORestToolkit.psd1
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
### creating an reverting snapshots  
the toolkit supports all 3 snaphot revert calls: move, toggle an copy
here is an example for creating a volume + snap and toggle both volumes after

```Powershell
PS C:\emcworld> $vol = New-SIOVolume -storagePoolID $pool.storagePoolID -VolumeName MasterVol -Thin -SizeInGB 8
PS C:\emcworld> New-SIOSnapshot -SystemID $sys.SystemID -volumeId $vol.VolumeID -SnapshotName Mastersnap

snapshotGroupId  volumeIdList
---------------  ------------
a7d3ba6100000001 {5b29022600000001}


PS C:\emcworld> Get-SIOvolumeList | ft

volumeName volumeID         creationTime useRmcache isObfuscated volumeType
---------- --------         ------------ ---------- ------------ ----------
MasterVol  5b29022500000000   1462403569       True        False ThinProvisioned
Mastersnap 5b29022600000001   1462403622      False        False Snapshot


PS C:\emcworld> Restore-SIOSnapshot -ancestorVolumeId 5b29022600000001 -volumeId
$vol.VolumeID -revertMode toggle

Commit Volume restore
Content of 5b29022500000000 and 5b29022600000001 will be switched, id´s remain
[N] No  [Y] Yes  [?] Hilfe (Standard ist "N"): y

executed toggle from 5b29022600000001 to 5b29022500000000
PS C:\emcworld> Get-SIOvolumeList | ft

volumeName volumeID         creationTime useRmcache isObfuscated volumeType
---------- --------         ------------ ---------- ------------ ----------
Mastersnap 5b29022600000001   1462403569      False        False ThinProvisioned
MasterVol  5b29022500000000   1462403622       True        False Snapshot


PS C:\emcworld>
```
#### moving a snaphot ( deleting the snap )

```Powershell
PS C:\emcworld> Restore-SIOSnapshot -ancestorVolumeId 5b29022500000000 -volumeId 5b290226
00000001 -revertMode move

Commit Volume restore
Content from 5b29022500000000 will be moved to 5b29022600000001, 5b29022500000000 will
be removed
[N] No  [Y] Yes  [?] Hilfe (Standard ist "N"): y
executed move from 5b29022500000000 to 5b29022600000001
PS C:\emcworld> Get-SIOvolumeList | ft

volumeName volumeID         creationTime useRmcache isObfuscated volumeType      consist
                                                                                 encyGro
                                                                                 upId
---------- --------         ------------ ---------- ------------ ----------      -------
MasterVol  5b29022500000000   1462403569       True        False ThinProvisioned

```


