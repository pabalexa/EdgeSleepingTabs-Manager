# EdgeSleepingTabs-Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) <!-- Puedes añadir más badges si lo deseas -->

PowerShell scripts to easily disable or re-enable Microsoft Edge's Sleeping Tabs feature system-wide via registry policy. Prevent unexpected tab reloads and keep important tabs always active. Ideal for users and administrators seeking consistent browser behavior.

---

## Table of Contents

- [About The Project](#about-the-project)
- [Problem Solved](#problem-solved)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Disabling Sleeping Tabs](#disabling-sleeping-tabs)
  - [Restoring Default Behavior (Enabling Sleeping Tabs)](#restoring-default-behavior-enabling-sleeping-tabs)
- [How It Works](#how-it-works)
- [Important Notes](#important-notes)
- [Contributing](#contributing)
- [License](#license)

---

## About The Project

This project provides two simple yet effective PowerShell scripts to manage the "Sleeping Tabs" feature in the Microsoft Edge browser. Sleeping Tabs is a feature designed by Microsoft to save system resources (RAM and CPU) by putting inactive background tabs into a suspended state. While beneficial for resource saving, it can sometimes cause tabs to reload their content when you switch back to them, which can be disruptive.

These scripts offer a programmatic way to control this feature for **all users** on a Windows machine by modifying the relevant system-wide registry policy.

## Problem Solved

- **Unexpected Tab Reloads:** Prevents tabs from automatically discarding their content and needing a full reload when revisited after inactivity.
- **Keeping Tabs Active:** Ensures specific web applications or pages remain fully active in the background without being suspended by Edge.
- **Consistent Behavior:** Provides a way for administrators or power users to enforce a consistent behavior regarding Sleeping Tabs across a system.

## Features

- **Disable Sleeping Tabs:** Runs a script (`Disable-EdgeSleepingTabs.ps1`) to set the necessary registry policy, preventing Edge from putting tabs to sleep.
- **Restore Default Behavior:** Runs a script (`Enable-EdgeSleepingTabs.ps1` or `Restore-EdgeSleepingTabsDefault.ps1` - _elige el nombre que prefieras_) to remove the custom policy, allowing Edge to use its default settings for Sleeping Tabs (usually enabled).
- **System-Wide:** Applies changes via HKLM registry key, affecting all user profiles on the machine.
- **Simple & Clear:** Easy-to-understand scripts with console output indicating success or failure.
- **Requires Admin Rights:** Ensures necessary permissions for registry modification.

## Prerequisites

Before using these scripts, ensure you have the following:

- Windows Operating System (Windows 10 / Windows 11 recommended)
- PowerShell (Version 5.1 or later usually included)
- Microsoft Edge browser installed
- **Administrator Privileges** on the machine to run the scripts.

## Getting Started

1.  **Download the Scripts:**
    - Clone this repository: `git clone https://github.com/YourUsername/EdgeSleepingTabs-Manager.git`
    - Or download the `.ps1` script files directly (`Disable-EdgeSleepingTabs.ps1` and `Enable-EdgeSleepingTabs.ps1` / `Restore-EdgeSleepingTabsDefault.ps1`).
2.  **Place them** in a convenient location on your computer.

## Usage

**IMPORTANT:** You MUST run these scripts with Administrator privileges.

### Disabling Sleeping Tabs

This will prevent Edge from putting inactive tabs to sleep.

1.  Open PowerShell **as Administrator**.
    - Search for "PowerShell" in the Start Menu, right-click it, and select "Run as administrator".
2.  Navigate to the directory where you saved the scripts using the `cd` command.
    ```powershell
    cd "C:\path\to\your\scripts"
    ```
3.  Execute the disable script:
    ```powershell
    .\Disable-EdgeSleepingTabs.ps1
    ```
4.  Follow the on-screen prompts. It will confirm the action upon successful completion.
5.  **Restart Microsoft Edge:** Close _all_ Edge windows completely and reopen the browser for the changes to take effect.

### Restoring Default Behavior (Enabling Sleeping Tabs)

This will remove the policy set by the disable script, allowing Edge to manage Sleeping Tabs according to its default settings or user preferences within Edge's settings menu.

1.  Open PowerShell **as Administrator**.
2.  Navigate to the script directory:
    ```powershell
    cd "C:\path\to\your\scripts"
    ```
3.  Execute the restore/enable script (use the correct filename you chose):
    ```powershell
    .\Enable-EdgeSleepingTabs.ps1
    # OR
    # .\Restore-EdgeSleepingTabsDefault.ps1
    ```
4.  The script will confirm if the policy was removed or if it wasn't set.
5.  **Restart Microsoft Edge:** Close _all_ Edge windows completely and reopen the browser.

**Verification:** You can often check applied policies by navigating to `edge://policy` within the Edge browser after restarting it. Look for the `SleepingTabsEnabled` policy.

## How It Works

The scripts interact directly with the Windows Registry:

- **Registry Path:** `HKLM:\SOFTWARE\Policies\Microsoft\Edge`
- **Policy Name:** `SleepingTabsEnabled` (DWORD Value)
- **Disable Script:** Creates the path if it doesn't exist and sets the `SleepingTabsEnabled` DWORD value to `0`. A value of `0` instructs Edge to disable the Sleeping Tabs feature.
- **Restore/Enable Script:** Checks if the `SleepingTabsEnabled` value exists at the specified path and removes it. When this specific policy value is absent, Edge reverts to its default behavior or other configured settings.

## Important Notes

- **System-Wide (HKLM):** These scripts modify `HKEY_LOCAL_MACHINE`. Changes apply to all users on the computer. For per-user settings (HKCU), the scripts would need modification.
- **RAM Usage:** Disabling Sleeping Tabs will likely increase the amount of RAM Microsoft Edge uses, especially if you keep many tabs open, as inactive tabs will no longer release their resources.
- **Edge Restart Required:** Changes to registry policies are typically only read by Edge during its startup process. A full restart of the browser is necessary after running either script.

## Contributing

Contributions are welcome! If you find issues or have suggestions for improvements, please feel free to:

1.  Open an Issue.
2.  Fork the repository and create a Pull Request.

## License

Distributed under the MIT License. See `LICENSE` file for more information. (Remember to add a `LICENSE` file containing the MIT license text to your repository).

---
