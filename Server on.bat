@echo off
REM ==============================================================
REM Wake-on-LAN (WoL) Magic Packet Sender
REM Sends a Magic Packet to wake up a remote PC or Linux server
REM ==============================================================
REM IMPORTANT:
REM This script WILL ONLY work if:
REM 1) The target device has a motherboard and BIOS/UEFI that support
REM    Wake-on-LAN
REM 2) WoL is enabled in BIOS/UEFI settings
REM 3) The target device is connected via Ethernet (WiFi does NOT support WoL)
REM 4) The network adapter (NIC) supports Magic Packet wake-up
REM
REM Also, for Ubuntu server users:
REM - WoL must be enabled in Ubuntu before the machine is shut down
REM - Without enabling WoL in Ubuntu, this script will not work
REM - You can enable it with:
REM   sudo ethtool -s <interface> wol g
REM - For persistence, configure it through NetworkManager or Netplan
REM
REM Requirements:
REM - Sender (Windows) and target device must be on the same local network
REM - UDP port 9 must be allowed on the local network
REM - The target device must be powered off (not just sleeping)
REM ==============================================================
REM Example:
REM TARGET MAC: 4C:52:62:AE:95:8E
REM BROADCAST IP: 192.168.0.255
REM ==============================================================
REM Edit the values below for your own setup:
SET TARGET_MAC=4C:52:62:AE:95:8E
SET BROADCAST_IP=192.168.0.255
SET BROADCAST_PORT=9

powershell.exe -NoProfile -Command ^
    "$Mac = '%TARGET_MAC%';" ^
    "$BroadcastIP = '%BROADCAST_IP%';" ^
    "$Port = %BROADCAST_PORT%;" ^
    "$MacByteArray = $Mac -split '[:-]' | ForEach-Object { [Convert]::ToByte($_, 16) };" ^
    "[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray * 16);" ^
    "$UdpClient = New-Object System.Net.Sockets.UdpClient;" ^
    "$UdpClient.Connect($BroadcastIP, $Port);" ^
    "$UdpClient.Send($MagicPacket, $MagicPacket.Length) | Out-Null;" ^
    "$UdpClient.Close();" ^
    "Write-Host 'Magic WoL packet sent to: %TARGET_MAC%' -ForegroundColor Green"

pause