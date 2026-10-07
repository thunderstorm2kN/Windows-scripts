@echo off
powershell.exe -NoProfile -Command ^
    "$Mac = '4C:52:62:AE:95:8E';" ^
    "$MacByteArray = $Mac -split '[:-]' | ForEach-Object { [Convert]::ToByte($_, 16) };" ^
    "[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray * 16);" ^
    "$UdpClient = New-Object System.Net.Sockets.UdpClient;" ^
    "$UdpClient.Connect('192.168.0.255', 9);" ^
    "$UdpClient.Send($MagicPacket, $MagicPacket.Length) | Out-Null;" ^
    "$UdpClient.Close();" ^
    "Write-Host 'Pachetul Magic WoL a fost trimis catre server!' -ForegroundColor Green"
pause