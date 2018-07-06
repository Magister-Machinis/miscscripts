param(
	[string]$searcher = ".\CbAutoWrapper.ps1"
)

$MyParam = $MyInvocation.MyCommand.Parameters

foreach($item in $MyParam.Keys)
{
	New-Item (Get-Variable $item).Value -ItemType File -ErrorAction SilentlyContinue
	(Get-Variable $item).Value = Resolve-Path (Get-Variable $item).Value 
	Write-Host "Creating $((Get-Variable $item).Value)"
}

function sleepbar($seconds)
{
    
    for($count = 0; $count -lt $seconds; $count++)
    {
        $percent = ($count / $seconds) * 100
        write-progress -id 1 -activity "Sleeping: " -status "=][=  $count" -percentcomplete $percent -secondsremaining ($seconds - $count)
        start-sleep -s 1
    }
    Write-Progress -id 1 -Completed -activity "Sleeping: "
}
$flag = $true
while($flag -eq $true)
{
	& $searcher
	sleepbar 300
}