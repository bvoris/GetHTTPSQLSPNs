############################################ 
#Get SQL SPNS 
############################################ 
$serviceType="MSSQLSvc" 
$spns = @{} 
$filter = "(servicePrincipalName=$serviceType/*)" 
$domain = New-Object System.DirectoryServices.DirectoryEntry 
$searcher = New-Object System.DirectoryServices.DirectorySearcher 
$searcher.SearchRoot = $domain 
$searcher.PageSize = 1000 
$searcher.Filter = $filter 
$results = $searcher.FindAll() 
foreach ($result in $results){ 
 $account = $result.GetDirectoryEntry() 
 foreach ($spn in $account.servicePrincipalName.Value){ 
  if($spn.contains("$serviceType/")){ 
   $spns[$("$spn`t$($account.samAccountName)")]=1; 
  } 
 } 
} 
$SQLSPNS = $spns.keys | sort-object  
$SQLSPNS 
############################################ 
#Get HTTP SPNS 
############################################ 
$serviceType="HTTP" 
$spns = @{} 
$filter = "(servicePrincipalName=$serviceType/*)" 
$domain = New-Object System.DirectoryServices.DirectoryEntry 
$searcher = New-Object System.DirectoryServices.DirectorySearcher 
$searcher.SearchRoot = $domain 
$searcher.PageSize = 1000 
$searcher.Filter = $filter 
$results = $searcher.FindAll() 
foreach ($result in $results){ 
 $account = $result.GetDirectoryEntry() 
 foreach ($spn in $account.servicePrincipalName.Value){ 
  if($spn.contains("$serviceType/")){ 
   $spns[$("$spn`t$($account.samAccountName)")]=1; 
  } 
 } 
} 
$HTTPSPNS = $spns.keys | sort-object 
$HTTPSPNS 
############################################ 
#Get Date 
############################################ 
$dated = (Get-Date -format F) 
 
############################################ 
#HTML Heading 
############################################ 
$htmlhead = @" 
<HEAD> 
<TITLE>SPN Report</TITLE> 
<style> 
table { 
    border-collapse: collapse; 
} 
 
table, td, th { 
    border: 1px solid black; 
} 
</style> 
</HEAD> 
"@ 
 
############################################ 
#HTML Body for report 
############################################ 
 
$htmlbody = @" 
 
<CENTER> 
<Font size=5><B>HTTP & SQL SPN Report</B></font></BR> 
<Font size=3>$dated<BR /> 
<TABLE cellpadding="10"> 
<TR bgcolor= #FEF7D6> 
<TD>CVR SQL SPN Report</TD> 
</TR> 
<TR bgcolor= #D9E3EA> 
<TD>$SQLSPNS</TD> 
</TR> 
<TR bgcolor= #FEF7D6> 
<TD>CVR HTTP SPN Report</TD> 
</TR> 
<TR bgcolor= #D9E3EA> 
<TD>$HTTPSPNS</TD> 
</TR> 
</TABLE> 
</CENTER></font> 
 
"@ 
 
############################################ 
#Date for file name variable 
############################################ 
$fileDate = get-date -uformat %Y-%m-%d 
 
############################################ 
#Report output & location 
############################################ 
ConvertTo-HTML -head $htmlhead -body $htmlbody | Out-File C:\CVRUserSPNReport-$fileDate.html 
$SQLSPNS | out-file -filepath C:\CVRUserSPNReport-$fileDate.txt 
$HTTPSPNS | out-file -filepath C:\CVRUserSPNReport-$fileDate.txt -append 
