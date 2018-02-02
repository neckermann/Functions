function Connect-UsersTerminalSession {
<#.SYNOPSIS
Connects via RDP to a shadow session of a user’s terminal server connection.
.DESCRIPTION
You can use this tool to assist users in the terminal server sessions.
It allows you to see what they see and even control the screen if you need to.
.PARAMETER User
Input the user id for who you would like to shadow
.PARAMETER ConnectionBroker
Input the connection broker used by the users for terminal services
.PARAMETER CollectionName
Input the collection name that user is using
.PARAMETER Control
This is just a switch to allow control access
.PARAMETER NoPrompt
This is just a switch allow suppression of prompt for permission from the user. GPO need set for this to work
.PARAMETER GetCollectionNames
This is just a switch to show you all the collection names for the connection broker you provided so you are able to get the CollectionName you need
.EXAMPLE
Connect-UsersTerminalSession -User MyBestUser -ConnectionBroker CONBROKER01 -CollectionName MyCollection -Control -NoPrompt
This will connect open a Shadow Session w/ control of MyBestUser's terminal session on the connection broker CONBROKER01 with the collection name MyCollection and will not prompt the user for permission for the connection
.EXAMPLE
Connect-UsersTerminalSession -User MyBestUser -ConnectionBroker CONBROKER01 -CollectionName MyCollection
This will connect prompt the user if a Shadow Session view only of MyBestUser's terminal session on the connection broker CONBROKER01 with the collection name MyCollection
#> 

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ConnectionBroker,
        [string]$User,
        [string]$CollectionName,
        [switch]$Control,
        [switch]$NoPrompt,
        [Parameter(ParameterSetName = 'GetCollectionNames')]
        [switch]$GetCollectionNames

    )
    BEGIN{}
    PROCESS{
            if($NoPrompt){
                if ($GetCollectionNames){
                    Get-RDSessionCollection -ConnectionBroker $ConnectionBroker
                }else{
                    if($Control){
                        if(Get-RDUserSession -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName|where UserName -Like "$UserID"){
                            $SessionInfo = Get-RDUserSession -CollectionName Terminal|where UserName -Like "$UserID"
                            mstsc.exe /v:($SessionInfo.ServerName) /shadow:($SessionInfo.SessionId) /control /noconsentprompt
                        }
                    }else{  if(Get-RDUserSession -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName|where UserName -Like "$UserID"){
                            $SessionInfo = Get-RDUserSession -CollectionName Terminal|where UserName -Like "$UserID"
                            mstsc.exe /v:($SessionInfo.ServerName) /shadow:($SessionInfo.SessionId) /noconsentprompt
                            }
                    }
                }
            }else{
                if ($GetCollectionNames){
                    Get-RDSessionCollection -ConnectionBroker $ConnectionBroker
                }else{
                    if($Control){
                        if(Get-RDUserSession -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName|where UserName -Like "$UserID"){
                            $SessionInfo = Get-RDUserSession -CollectionName Terminal|where UserName -Like "$UserID"
                            mstsc.exe /v:($SessionInfo.ServerName) /shadow:($SessionInfo.SessionId) /control
                        }
                    }else{  if(Get-RDUserSession -ConnectionBroker $ConnectionBroker -CollectionName $CollectionName|where UserName -Like "$UserID"){
                            $SessionInfo = Get-RDUserSession -CollectionName Terminal|where UserName -Like "$UserID"
                            mstsc.exe /v:($SessionInfo.ServerName) /shadow:($SessionInfo.SessionId)
                            }
                    }
                }


            }
        }
    END{}
}
