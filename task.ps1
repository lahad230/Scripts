<#
.SYNOPSIS
    Creates a scheduled task that runs PS script every x minutes,
    then the task is disabled, after that it will print all the running tasks.

.PARAMETER Sleep
    sets the time in seconds until the task will be disabled,
    and the printing of the list of tasks.
.PARAMETER TaskName
    sets the name oif the task in the task scheduler.
#>

param(
    [parameter(Mandatory)]
    $Sleep,
    [parameter(Mandatory)]
    $TaskName
)
function Create-Task($TaskName, $ScriptPath, $Minutes){

    <#
    .SYNOPSIS
        Creates an task to run a certain PS script in the task scheduler, that run every x minutes.

    .PARAMETER TaskName
        sets the name of the task in the task scheduler.
    .PARAMETER ScriptPath
        the full path of the script you want to run.
    .PARAMETER Minutes
        the frequncy in minutes in which you want the task to repeat. 
#>
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-file $ScriptPath"
    $trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Minutes)
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName
}

function Change-TaskStatus($Name){

    <#
    .SYNOPSIS
        Changes status of a task from running/ready to disabled and vice versa.
    .PARAMETER Name
        The name of the task that will have its status changed.
    #>
    $state = (Get-ScheduledTask | Where-Object TaskName -eq $Name ).State

    if($state -ne "Disabled"){
        Disable-ScheduledTask -TaskName $Name
    }
    else {
        Enable-ScheduledTask -TaskName $Name
    }
    $state = (Get-ScheduledTask | Where-Object TaskName -eq $Name ).State
}

function Get-AllTasks{

    <#
    .SYNOPSIS
        Lists all the running tasks.
    #>
    (Get-ScheduledTask | Where-Object{$_.State -eq "Running"} ).TaskName
}

Create-Task -TaskName $TaskName -ScriptPath "F:\DevOps-bootcamp\Projects\2\note.ps1" -Minutes 1

Start-Sleep -Seconds $Sleep

Change-TaskStatus -Name $TaskName

Get-AllTasks

 

