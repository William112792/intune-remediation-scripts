# 🛠️ Intune Remediation Scripts Framework



This repository provides a structured approach to designing, building, and scaling **Microsoft Intune Remediation Scripts and Application Deployments**.

The focus is on creating **modular, reusable automation components** that are:

* Predictable
* Scalable
* Environment-agnostic
* Easy to maintain

---

# 👋 Overview

Intune automation is built on **modular execution logic**.

### Core Models

## 🔧 Remediation Scripts

* Detection Script
* Remediation Script

## 📦 Applications

* Detection
* Install
* Uninstall

Understanding how these components interact is critical for **reliable and scalable deployments**.

---

# 📂 Example Implementations

These are **real working examples** from this repository.

---

## 📦 Application Example — TextExpander

### Detection Scripts

* https://github.com/William112792/intune-remediation-scripts/blob/main/Apps/TextExpander/DET_TextExpander_v8.4.2-v254.8.4.209.ps1
* https://github.com/William112792/intune-remediation-scripts/blob/main/Apps/TextExpander-Alt/DET_ALT_TextExpander.ps1

### Install / App Logic

* https://github.com/William112792/intune-remediation-scripts/blob/main/Apps/TextExpander/APP_TextExpander.ps1
* https://github.com/William112792/intune-remediation-scripts/blob/main/Apps/TextExpander-Alt/install.ps1

### Uninstall Logic

* https://github.com/William112792/intune-remediation-scripts/blob/main/Apps/TextExpander-Alt/uninstall.ps1

---

## 🔧 Remediation Example — MSPaint Removal

### Detection

* https://github.com/William112792/intune-remediation-scripts/blob/main/Rems/MSPaint/DET_Uninstall_MSPaint.ps1

### Remediation

* https://github.com/William112792/intune-remediation-scripts/blob/main/Rems/MSPaint/REM_Uninstall_MSPaint.ps1

---

## 🔧 Remediation Example — TextExpander Cleanup

### Detection

* https://github.com/William112792/intune-remediation-scripts/blob/main/Rems/TextExpander/DET_Removal_TextExpander.ps1

### Remediation

* https://github.com/William112792/intune-remediation-scripts/blob/main/Rems/TextExpander/REM_TextExpander.ps1

---

# 🧩 Core Architecture

## 1. Remediation Scripts

### Components

#### 🔍 Detection Script

* Evaluates system state
* Returns:

  * `Exit 0` → Compliant (no action)
  * `Exit 1` → Non-compliant (triggers remediation)

#### 🔧 Remediation Script

* Executes corrective action
* Functions as the **execution layer**

---

### Execution Flow

```text id="rem-flow"
Group Assignment
   ↓
Detection Script
   ↓ (If Exit 1)
Remediation Script
```

---

### Important Notes

* Execution depends on **group assignment**
* Runs on a **scheduled cadence**
* Timing is **eventually consistent**, not exact

---

## 2. Application Model

### Components

* 🔍 Detection
* 📦 Install
* ❌ Uninstall

---

### Execution Flow

```text id="app-flow"
Group Assignment
   ↓
Detection
   ↓
Install / Uninstall Decision
```

---

### Install Command Example

```powershell id="install-cmd"
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -command .\install.ps1
```

---

### Uninstall Command Example

```powershell id="uninstall-cmd"
%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -command .\uninstall.ps1
```

---

## 🔍 Detection Strategy

### PowerShell Detection (Recommended)

**Advantages**

* Full logic control
* Multi-condition validation
* Environment-aware decisions

---

### Native Intune Detection Rules

**Advantages**

* Faster setup
* Simpler configuration

**Limitations**

* Limited flexibility
* Less scalable logic

---

# 📦 Application Packaging

## MSI (Simple Deployments)

**Pros**

* Native Intune support
* Minimal configuration

**Cons**

* Limited flexibility
* Cannot easily chain dependencies

**Common Parameter**

```text id="msi-param"
/qn
```

---

## Win32 Apps (.intunewin)

### Tool Required

* IntuneWinAppUtil

---

### Behavior

* Packages folder → `.intunewin`
* Extracts on endpoint before execution

---

### Recommended Structure

```text id="win32-structure"
/AppName/
  ├── install.ps1
  ├── uninstall.ps1
  ├── detection.ps1
  └── binaries/
```

---

### Key Insight

Detection scripts can be updated independently
→ No need to rebuild `.intunewin` for detection changes

---

# 🔇 Silent Installation Strategy

Different vendors use different installer frameworks.

---

### Common Silent Switches

```text id="silent-switches"
/S
/S /v/qn
/qn
/quiet /norestart
/VERYSILENT
/install /q /norestart
/s /v"ACCEPT_EULA=Yes" /v/qn
```

---

### Common Installer Types

* MSI
* Inno Setup
* NSIS

---

### Tooling

* Universal Silent Switch Finder (USSF)
  *(Helpful, not guaranteed accurate)*

---

# ⚙️ Scheduling & Execution Realities

## Remediation Scripts

* Run on defined schedule
* Execution is **not real-time**

---

## Deterministic Execution (Workaround)

For strict timing:

### Strategy

1. Deploy script via Intune
2. Store locally
3. Execute using:

   * Task Scheduler
   * Registry run keys
   * Startup / Logon triggers

---

### Result

* Predictable execution
* Higher reliability for critical tasks

---

# 🏗️ Advanced Use Case

## Workstation as Automation Node

### Approach

* Deploy scripts via Intune
* Trigger execution locally
* Run continuously or event-based

---

### Use Cases

* Cleanup automation
* Monitoring
* Background processing
* Notification systems

---

# ⚠️ Platform Limitation

* Intune does **not support Windows Server OS**

### Workaround

* Use Windows endpoints to simulate server workloads

---

# 📛 Naming Convention Strategy

Consistency enables scale.

---

## Recommended Formats

### Remediation Scripts

```
REM_<Category>_<Purpose>_<Scope>
```

### Applications

```
APP_<Vendor>_<Application>_<Version>
```

### Detection Scripts

```
DET_<AppOrFunction>_<Check>
```

---

## Examples

* REM_Security_DefenderFix_Device
* APP_Microsoft_OneDrive_Enterprise
* DET_OneDrive_Installed

---

# 🔗 Layered Application Dependencies

Win32 apps support **dependency chaining**.

---

## Execution Chain Example

```text id="dependency-chain"
App A (Dependency)
   ↓
App B (Core App)
   ↓
App C (Configuration)
```

---

## Use Cases

* Runtime → Application → Plugin
* Base software → Extensions
* Security baseline → Policy enforcement

---

## Key Considerations

* Each dependency requires detection logic
* Failures block downstream installs
* Keep chains modular and simple

---

# 🧠 Design Philosophy

* Modular automation design
* Separation of detection vs execution
* Scalable naming conventions
* Built around real-world constraints

---

# 🛠️ Planned Enhancements

* Script templates
* Logging framework
* Standardized output format
* Graph API integration
* Automated deployment pipelines

---

# 📌 Key Takeaways

* Detection drives execution
* Remediation = controlled enforcement
* Scheduling is not precise
* Packaging affects flexibility
* Naming conventions enable scale

---

# 👤 Author

Billy Gordon
Endpoint Automation Engineer

Focus:

* Endpoint automation (Intune)
* PowerShell-driven frameworks
* Scalable deployment architecture
