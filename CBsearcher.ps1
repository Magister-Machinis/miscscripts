#needed config items are cb, namelist, hashlist
param (
[string]$configfile=".\config.csv"
)
$MyParam = $MyInvocation.MyCommand.Parameters
foreach($item in $MyParam.Keys)
{
	New-Item (Get-Variable $item).Value -ItemType File -ErrorAction SilentlyContinue
	(Get-Variable $item).Value = Resolve-Path (Get-Variable $item).Value 
	Write-Host "Creating $((Get-Variable $item).Value)"
}


$auth = import-csv $configfile
$key = @{'X-AUTH-TOKEN' = $auth.cb}
$searcher =@()
$hashsearcher = @()
foreach($item in $auth.namelist)
{
	$searcher += $item
}
foreach($item in $auth.hashlist)
{
	$hashsearcher+= $item
}
$searcher = $searcher | sort -unique
$hashsearcher = $hashsearcher | sort -unique
$refined = @()
$count = 0
foreach($item in $searcher)
{
	if($count -gt 25)
	{
		$count = 0
		start-sleep -s 61
	}
	$count++
	#$url = 'https://api-prod05.conferdeploy.net/integrationServices/v3/event?applicationName='+$item+'&rows=1000000000&searchWindow=2w'
	$url = 'https://api.confer.net/integrationServices/v3/event?applicationName='+$item+'&rows=1000000000&searchWindow=2w'
	$url
	$results = invoke-restmethod -uri "$url" -Header $key -method GET
	$results

	foreach($item in $results.results)
	{
		$refined += $item.deviceDetails.deviceName
	}
}
foreach($item in $hashsearcher)
{
	if($count -gt 25)
	{
		$count = 0
		start-sleep -s 61
	}
	$count++
	#$url = 'https://api-prod05.conferdeploy.net/integrationServices/v3/event?sha256Hash='+$item+'&rows=1000000000&searchWindow=2w'
	$url = 'https://api.confer.net/integrationServices/v3/event?sha256Hash='+$item+'&rows=1000000000&searchWindow=2w'
	$url
	$results = invoke-restmethod -uri "$url" -Header $key -method GET
	$results

	foreach($item in $results.results)
	{
		$refined += $item.deviceDetails.deviceName
	}
}

#$refined | group | select Name,Count | sort Count -descending
#($refined | sort -unique).Length
$refined += Get-Content -Path ".\Devicecount.txt"
$refined = $refined | sort -Unique
$refined
$refined.Length
$refined | Out-File -FilePath ".\Devicecount.txt"
