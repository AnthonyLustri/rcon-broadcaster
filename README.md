# RCON Broadcaster

Automate single broadcast messages to all your servers using **PowerShell** and **Windows Task Scheduler**.  
This script sends server-wide broadcasts (like maintenance warnings) via RCON and is designed to run quietly in the background.

---

## ✨ Features

- 🔕 Runs minimized / invisible when automated
- 📢 Sends a broadcast to multiple servers
- 🕒 Fully compatible with **Windows Task Scheduler**
- ⚙️ Supports multiple servers in a single configuration
- 🔒 Safe template with placeholder IPs and passwords

---

## 🗂️ What the Script Does

1. Checks that `mcrcon.exe` exists at the specified path.
2. Iterates over all configured ARK servers.
3. Sends a single broadcast message to each server.
4. Waits 5 seconds between servers for stability.
5. Logs output and errors in the PowerShell console.
6. Exits automatically when complete.

---

## 📁 Server Configuration

The script supports multiple servers configured in an array. Example:

```powershell
$servers = @(
    @{
        Name = "The Island"
        RconIp = "127.0.0.1"
        RconPort = 27020
        RconPassword = "YourRconPasswordHere"
    },
    @{
        Name = "Server1"
        RconIp = "127.0.0.1"
        RconPort = 27021
        RconPassword = "YourRconPasswordHere"
    },
    @{
        Name = "Server2"
        RconIp = "127.0.0.1"
        RconPort = 27022
        RconPassword = "YourRconPasswordHere"
    }
    # Add more servers by duplicating the block above
)

## 🔧 Requirements

- Windows OS / Server 2016+  
- PowerShell 5.1 or newer  
- ARK server(s) with RCON enabled  
- `mcrcon.exe` available on the system (update `$mcrconPath`)  
- Write access to the folder containing the script (optional logs)  

---

## 🚀 Setup with Windows Task Scheduler

1. Open **Task Scheduler** → **Create Task**.  
2. **General Tab**:  
   - Name: `RconBroadcaster`  
   - Run whether user is logged on or not  
   - Run with highest privileges  
3. **Triggers Tab**:  
   - Choose **Daily**, **Weekly**, or **At startup** depending on your schedule  
4. **Actions Tab**:  
   - Action: **Start a program**  
   - Program/script: `powershell.exe`  
   - Arguments:  
     ```
     -ExecutionPolicy Bypass -File "C:\Path\To\Your\Script\RconBroadcaster.ps1"
     ```  
5. **Conditions & Settings Tabs**: Optional settings like “Wake the computer to run task”  
6. Click **OK** and enter your credentials if required.

✅ Task Scheduler will now automatically run your broadcast script on the chosen schedule.

---

## ⚠️ Important Notes

- The script only broadcasts messages – it does **not** shut down servers.  
- Ensure your IPs, ports, and passwords are correct.  
- Keep `mcrcon.exe` updated for compatibility.  
- Wait time between broadcasts (`Start-Sleep -Seconds 5`) ensures stability for multiple servers.  
- Running as Administrator is recommended to avoid permission issues.  

