#1.	We need to create a script that identifies whether or not a website is working before continue the deployment. 
#If the website is not working, write the response error in a TXT file.


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PSDefaultParameterValues['Out-File:Encoding']="utf8"
function Write-Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
        
    )
    # Open a stream writer
    $File = './result.txt'
    Write-Output "$(Get-Date) - $LogMessage"  | Out-file $File -append
}


try {

    
    #$urlStr = Read-Host "Please enter URL to check"
    $urlStr = "https://www.google.com/tesdt"
    [uri]$urlStr >$null

    # First we create the request.
    $HTTPS_Request = [System.Net.WebRequest]::Create("$urlStr")


    # We then get a response from the site.
    $HTTPS_Response = $HTTPS_Request.GetResponse()


    # We then get the HTTP code as an integer.
    $HTTPS_Status = [int]$HTTPS_Response.StatusCode
    $HTTPS_StatusDesc = [string]$HTTPS_Response.StatusDescription

    Write-Host "HTTP CODE: $HTTPS_Status"

    if ($HTTPS_Status -ne 200 ){
        Write-Log-Message "HTTP CODE: $HTTPS_Status"
        Write-Log-Message "HTTP CODE DESCRIPTION: $HTTPS_StatusDesc"
        Write-Log-Message "Error - issue with Service. Please investigate."
        exit 1
    }
    
    
    # Finally, we clean up the http request by closing it.
    $HTTPS_Response.Close()
    $HTTPS_Response.Dispose()
    #Read-Host -Prompt “Press Enter to exit”
   
}
catch {
    Write-Log-Message( "Error Message: " + $_.Exception.Message)
    # Write-Log-Message("Error in Line: " + $_.InvocationInfo.Line)
    # Write-Log-Message("Error in Line Number: " + $_.InvocationInfo.ScriptLineNumber)
    # Write-Log-Message("Error Item Name: " + $_.Exception.ItemName)
    exit 1
}


