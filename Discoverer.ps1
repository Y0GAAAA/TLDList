 Param(
     [Parameter(Mandatory=$true, Position=0, HelpMessage="base url without domain extension (example : http://google)")]
     $baseurl
   )

Function IsReacheable($url) {

    Try {

        Invoke-WebRequest $url

        return $TRUE

   }
   Catch 
   {
   
        return $FALSE

   }

}

Function SanitizeUrl($url) {

    $url = $url.TrimEnd('.')

    If (!$url.StartsWith("http")) {
    
        $url = ("http://" + $url)

    }

    return $url

}

Set-Variable fName -option Constant -value "list.bin"

$fPath = [System.IO.Path]::Combine((Get-Location), $fName)

$domains = [System.IO.File]::ReadAllLines($fPath)

$baseurl = SanitizeUrl($baseurl)

$MaxCount = $domains.Count
$ProcessedCount = 0

foreach($domain in $domains) {

   $finalurl = ($baseurl + "." + $domain)

   if (IsReacheable($finalurl)) {
   
        Write-Host $finalurl
   
   }

   $ProcessedCount++

   $Progress = ($ProcessedCount.ToString() + "/" + $MaxCount.ToString())

   $host.UI.RawUI.WindowTitle = $Progress

}