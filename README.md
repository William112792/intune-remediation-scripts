# 🛠️ Intune Remediation Scripts Framework

This repository provides a structured approach to building, naming, and scaling **Microsoft Intune Remediation Scripts and Application Deployments**.

The goal is to standardize how detection, remediation, and application logic are built so they are:
- Reusable
- Predictable
- Scalable across environments

---

# 👋 Overview

Microsoft Intune automation is built around **modular execution logic**.

At its core:

## Remediation Scripts
- Detection Script
- Remediation Script

## Applications
- Detection
- Install
- Uninstall

Understanding how these components interact is critical to building reliable deployments.

---

# 🧩 Core Architecture

## 1. Remediation Scripts

### Components

#### 🔍 Detection Script
- Evaluates system state
- Returns:
  - `Exit 0` → Compliant (No action)
  - `Exit 1` → Non-compliant (Triggers remediation)

#### 🔧 Remediation Script
- Executes corrective action
- Equivalent to an **installation phase**

---

### Execution Flow

Group Assignment → Detection Script → (If Failed) → Remediation Script


---

### Important Notes

- Execution is based on **assigned groups**
- Runs on a **schedule (cadence)**
- Scheduling is **not exact**
  - Delays can occur
  - Should not be relied on for strict timing

---

## 2. Application Model

Applications extend this model with an additional component:

### Components

#### 🔍 Detection
#### 📦 Install
#### ❌ Uninstall

---

### Execution Flow

Group Assignment → Detection → Install / Uninstall Decision


---

### Install Command Example

powershell:
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -command .\install.ps1

### Uninstall Command Example

powershell:
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -command .\uninstall.ps1

## Detection Behavior
Executes only if assigned group matches
Uses:
PowerShell detection scripts (recommended)
OR native Intune rule-based detection

## 🧠 Detection Strategy
PowerShell Detection (Recommended)
### Benefits
- Full customization
- Complex logic support
- Multi-condition evaluation

### Native Detection Rules
#### Benefits
- Simpler setup
- Faster configuration
#### Limitations
- Less flexible
- Limited logic depth

## 📦 Application Packaging
MSI (Streamlined Deployment)
### Advantages
- Native support in Intune
- Simple configuration
### Limitations
Cannot combine:
- MST transforms
- Additional dependencies
### Common Parameter
/qn

## Win32 Apps (INTUNEWIN)
Required Tool
- IntuneWinAppUtil

### Behavior
- Packages folder into .intunewin
- Extracts on endpoint before execution

### Recommended Structure
/AppName/
-     install.ps1
-     uninstall.ps1
-     detection.ps1
-     binaries/

### Key Insight
Detection scripts can be updated independently
.intunewin does NOT need to be rebuilt for detection updates

## 🔇 Silent Installation Strategy

Vendors use different installer frameworks.

Common Silent Switches:
- /S
- /S /v/qn
- /qn
- /quiet /norestart
- /VERYSILENT
- /install /q /norestart
- /s /v"ACCEPT_EULA=Yes" /v/qn
id="silent-switches"

---

### Installer Frameworks

- Inno Setup
- NSIS
- MSI-based installers

---

### Tooling

- Universal Silent Switch Finder (USSF)
  - Helps identify potential installer types
  - Not guaranteed accuracy

---

# ⚙️ Scheduling & Execution Realities

## Remediation Scripts

- Run on defined schedule
- Execution is **eventually consistent**, not exact

---

## Tight Execution Requirements (Workaround)

For strict timing needs:

### Strategy

1. Use Intune to deploy scripts/files
2. Store locally on device
3. Execute via:
   - Task Scheduler
   - Registry run keys
   - Startup / Logon triggers

---

### Result

- Deterministic execution timing
- Greater reliability for critical tasks

---

# 🏗️ Advanced Use Case

## Turning a Workstation into an Automation Node

### Approach

- Deploy scripts via Intune
- Use Task Scheduler for execution
- Run scripts continuously or on triggers

---

### Optional Enhancements

- Run scripts as services using:
  - `INSTSRV`
  - `SRVANY`

---

### Use Cases

- Cleanup automation
- Monitoring tasks
- Notification systems
- Background processing

---

# ⚠️ Platform Limitation

- Intune does NOT support Windows Server OS (currently)
- Workaround:
  - Use Windows endpoints to run server-like workloads

---

# 📛 Naming Convention Strategy

Consistency is critical.

---

## Recommended Format

### Remediation Scripts

REM_<Category><Purpose><Scope>

### Applications

APP_<Vendor><Application><Version>

### Detection Scripts

DET_<AppOrFunction>_<Check>

---

## Example

- REM_Security_DefenderFix_Device
- APP_Microsoft_OneDrive_Enterprise
- DET_OneDrive_Installed

---

# 🔗 Layered Application Dependencies (Win32 / INTUNEWIN)

Custom Win32 applications packaged as .intunewin support dependency chaining, allowing applications to be installed in a defined execution order.

## Purpose
- Enforce prerequisite installations
- Build layered deployments
- Reduce installation failures due to missing components

---

## How It Works
- Applications can be configured with dependencies in Intune
- Dependent apps install before the primary app
- Detection logic ensures each layer is validated before proceeding

---

## Example Execution Chain
App A (Runtime / Dependency)
   ↓
App B (Core Application)
   ↓
App C (Configuration / Add-on)

---

## Practical Use Cases
- Install Visual C++ / .NET before application deployment
- Deploy base software before plugins or extensions
- Layer security tools before enabling policies
- Build complete environments through modular app stacks

---

## Key Considerations
- Each dependency must have a valid detection method
- Failures in dependencies will block downstream installs
- Avoid overly complex chains to reduce troubleshooting difficulty
- Keep dependencies modular and reusable

---

# 🔗 Dependency Strategy

Define dependencies where possible:

- Script dependencies
- Application prerequisites
- Execution order

---

### Best Practices

- Avoid hard dependencies when possible
- Use detection logic to validate prerequisites
- Fail gracefully with clear output

---

# 🧠 Design Philosophy

This repository is built around:

- Modular automation
- Clear separation of detection vs execution
- Scalable naming standards
- Real-world deployment constraints

---

# 🛠️ Planned Enhancements

- Reusable script templates
- Logging framework
- Standardized output format
- Graph API integration
- Automated deployment pipelines

---

# 📌 Key Takeaways

- Detection drives everything
- Remediation = controlled execution
- Scheduling is not real-time
- Packaging impacts flexibility
- Naming conventions enable scale

---

# 👤 Author

Billy Gordon  
Endpoint Automation Engineer  

Focused on:
- Scalable endpoint automation
- Intune architecture and deployment
- PowerShell-driven remediation frameworks




