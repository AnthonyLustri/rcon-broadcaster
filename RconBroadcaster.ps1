# Requires PowerShell 5.1 or newer (default on Windows 10/Server 2016+)

<#
.SYNOPSIS
    Automates a single timed shutdown broadcast for ARK servers.
.DESCRIPTION
    Sends a single broadcast message to all configured ARK servers via RCON.
    Designed to be triggered manually or by Windows Task Scheduler.
    The actual server shutdown should be handled externally.
    Pre-requisites:
    - ARK server RCON enabled with password set in GameUserSettings.ini.
    - RCON port open in firewall.
    - An RCON client executable (e.g., mcrcon.exe) accessible by this script.
#>

# --- Configuration ---
# Path to the mcrcon.exe executable (update to your actual path)
$mcrconPath = "C:\Path\To\mcrcon.exe"

# --- Server Configurations ---
# Replace IPs, ports, and passwords with your actual server info
$servers = @(
    @{
        Name = "The Island"
        RconIp = "127.0.0.1"
        RconPort = 27020
        RconPassword = "YourRconPasswordHere"
    },
    @{
        Name = "Ragnarok"
        RconIp = "127.0.0.1"
        RconPort = 27021
        RconPassword = "YourRconPasswordHere"
    },
    @{
        Name = "Scorched Earth"
        RconIp = "127.0.0.1"
        RconPort = 27022
        RconPassword = "YourRconPasswordHere"
    },
    @{
        Name = "The Center"
        RconIp = "127.0.0.1"
        RconPort = 27023
        RconPassword = "YourRconPasswordHere"
    }
    # Add more servers by duplicating the block above
)

# --- Function to send RCON command using mcrcon.exe ---
function Send-ArkRconCommand {
    param(
        [string]$RconIp,
        [int]$RconPort,
        [string]$RconPassword,
        [string]$Command,
        [string]$ServerName
    )

    Write-Host "[$ServerName] Sending RCON command: $Command"

    $tempOutputPath = [System.IO.Path]::GetTempFileName()
    $tempErrorPath = [System.IO.Path]::GetTempFileName()

    try {
        $arguments = "-H $($RconIp) -P $($RconPort) -p $($RconPassword) `"$Command`""
        $process = Start-Process -FilePath $mcrconPath `
                                 -ArgumentList $arguments `
                                 -NoNewWindow `
                                 -Wait `
                                 -RedirectStandardOutput $tempOutputPath `
                                 -RedirectStandardError $tempErrorPath `
                                 -PassThru

        $output = Get-Content $tempOutputPath | Out-String
        $errorOutput = Get-Content $tempErrorPath | Out-String

        if ($output) { Write-Host "[$ServerName] Output: $output" }
        if ($errorOutput) { Write-Warning "[$ServerName] Error: $errorOutput" }

        if ($process.ExitCode -eq 0) {
            Write-Host "[$ServerName] RCON command sent successfully."
        } else {
            Write-Warning "[$ServerName] mcrcon exited with code $($process.ExitCode)."
        }

    } catch {
        Write-Warning "[$ServerName] Failed to execute mcrcon: $($_.Exception.Message)"
    } finally {
        Remove-Item $tempOutputPath -ErrorAction SilentlyContinue -Force
        Remove-Item $tempErrorPath -ErrorAction SilentlyContinue -Force
    }
}

# --- Main Script Logic ---
Write-Host "--- ARK Server RCON Broadcast Routine Initiated ---"

if (-not (Test-Path $mcrconPath)) {
    Write-Error "mcrcon.exe not found at '$mcrconPath'. Update the path to your executable."
    exit 1
}

# --- Broadcast Message ---
$broadcastMessage = "ATTENTION SURVIVORS on {0}: The server will shut down in 15 minutes for maintenance."

foreach ($server in $servers) {
    $finalMessage = $broadcastMessage -f $server.Name
    Write-Host "Processing server: $($server.Name) ($($server.RconIp):$($server.RconPort))"
    Send-ArkRconCommand -RconIp $server.RconIp -RconPort $server.RconPort -RconPassword $server.RconPassword -Command "Broadcast $finalMessage" -ServerName $server.Name
    Start-Sleep -Seconds 5
}

Write-Host "--- Broadcast sent to all servers. Exiting script. ---"
exit 0
