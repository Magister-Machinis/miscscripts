$key = @{'X-AUTH-TOKEN' = 'GWWNPWL1NZ7Y6KIGGN7RZ8UC/FBIYPINDAA'}
$searcher =@('purgecodev2.exe')
$hashsearcher = @()#doesnt appear to work well
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
	$url = 'https://api-prod05.conferdeploy.net/integrationServices/v3/event?applicationName='+$item+'&rows=1000000000'
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
	$url = 'https://api-prod05.conferdeploy.net/integrationServices/v3/event?sha256hash='+$item+'&rows=1000000000'
	$url
	$results = invoke-restmethod -uri "$url" -Header $key -method GET
	$results

	foreach($item in $results.results)
	{
		$refined += $item.deviceDetails.deviceName
	}
}

$refined | group | select Name,Count | sort Count -descending
($refined | sort -unique).Length
