# Script to update the IP binding for a Visual Studio Test Controller with multiple NICs.
# NOTE - script user will need permission to modify the specified config file.
# Also, this script may adjust the formatting of the config file.
# For more info, see MSDN 'How to: Bind a Test Controller or Test Agent to a Network Adapter' (https://msdn.microsoft.com/en-us/library/ff934571.aspx)

# Author: Luke McQuade 30-Jan-2015. License: MIT (see end of file)

param(
  $NICAlias = "Ethernet", # Alias of the network adapter you want the Test Controller to communicate on - you can find it by manually running Powershell command Get-NetIPAddress
  $ControllerConfig = "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\QTController.exe.config" # Adjust if path is different or using 64 bit controller (QTController64.exe.config)
)

# Get current IP address
try
{
  $IPInfo = Get-NetIPAddress -InterfaceAlias $NICAlias -AddressFamily IPv4
} catch { throw "Couldn't get IP address info for adapter $NICAlias. $_" }

$currentIP = $IPInfo.IPAddress
Write-Host "Current IP address for adapter $NICAlias is $currentIP"

# Look up Controller's configured binding address
$configXml = [xml](Get-Content $ControllerConfig)
if ($configXml -eq $null) { throw "Couldn't load Controller config XML from $ControllerConfig" }
$bindingNode = $configXml.configuration.appSettings.add | where { $_.key -like "BindTo" }
if ($bindingNode -eq $null) {
  Write-Host "BindTo entry not found in config file. Ending. If you meant to run this script, manually add an entry and try again."
  return
}
try {
  $bindingIP = [IPAddress]$bindingNode.value
} catch { throw }
Write-Host "Current Controller binding IP is $bindingIP. From file $ControllerConfig"

# Compare and update binding address
if ($currentIP -eq $bindingIP) {
  Write-Host "IP addresses match. Ending."
  return
} else {
  $bindingNode.value = $currentIP
  try {
    $configXml.Save($ControllerConfig)
  } catch { throw "Couldn't update Controller config file, try altering permissions or running the script as admin. $_" }
  Write-Host "Successfully updated the Controller config file."
}

<#
The MIT License (MIT)

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>