<#
.SYNOPSIS
Remove Built-in WindowsApplicaitons from local or remote computer(s)
.DESCRIPTION
This function will help you clean up a Online windows installation of a remote or local computer. It will collect a list of all the built in apps and `n
prompt you if you would like to remove them from the system. You are prompted Y/N for each application that it finds.
.PARAMETER ComputerName
Input computer name or names to start removing applicaitons from. If left blank it will work on the local computer.
.EXAMPLE
Remove-BuiltInWindowsApps -ComputerName TESTCOM01
Builds a list of Built in Windows applications on TESTCOM01 and prompts you if you want to remove them.
#>

function Remove-BuiltInWindowsApps  {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName
    )
    BEGIN{}
    PROCESS{
        If($ComputerName -eq $null){
            $ProvisionedApps = Get-ProvisionedAppxPackage -Online | Select-Object PackageName
            foreach ($ProvisionedApp in $ProvisionedApps){
                $Response = Read-Host "Would you like to completely remove $ProvisionedApp from this computer? Y/N"
                    if($Response -like "Y"){
                        Remove-AppxProvisionedPackage -Online -PackageName ($ProvisionedApp).PackageName
                    }
            }
        }else{
            foreach ($Computer in $ComputerName){
                if (Test-Connection $Computer -Count 1 -qu){
                    Invoke-Command -ComputerName $Computer -ScriptBlock {
                        $ProvisionedApps = Get-ProvisionedAppxPackage -Online | Select-Object PackageName
                            foreach ($ProvisionedApp in $ProvisionedApps){
                                $Response = Read-Host "Would you like to completely remove $ProvisionedApp from $ENV:ComputerName? Y/N"
                                    if($Response -like "Y"){
                                        Remove-AppxProvisionedPackage -Online -PackageName ($ProvisionedApp).PackageName
                                    } 
                            }
                    }
                }else{
                    Write-Host "Was not able to connect to $Computer, please verify it is on!"
                }
            }
        }
    }
    END{}
}
