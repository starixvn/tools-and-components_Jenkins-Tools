$conversationId = $args[0]
$message = $args[1]

$Body = @{
    token = "0A40aOc7CtpzjbBSJu8KNWQRoXyjRvf9"
    conversationId = $conversationId
    message = $message    
}
$skynexBotUrl = "https://bot.nexdev.net/skynex/api/messages/forwardwithtoken"

Invoke-WebRequest $skynexBotUrl -Body $Body -Method 'POST' -ContentType 'application/x-www-form-urlencoded; charset=utf-8'