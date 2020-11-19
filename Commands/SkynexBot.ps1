$conversationId = $args[0]
$message = $args[1]

$Body = @{
    token = "0A40aOc7CtpzjbBSJu8KNWQRoXyjRvf9"
    conversationId = $conversationId
    message = $message    
}
$skynexBotUrl = "https://bot.nexdev.net/skynex/api/messages/forwardwithtoken"

add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

Invoke-WebRequest $skynexBotUrl -Body $Body -Method 'POST' -ContentType 'application/x-www-form-urlencoded; charset=utf-8'