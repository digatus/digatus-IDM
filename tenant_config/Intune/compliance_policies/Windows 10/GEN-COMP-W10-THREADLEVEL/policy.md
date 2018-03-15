Compliance policy name: GEN-COMP-W10-THREADLEVEL
================================================


1. Properties
-------------

### Description
For threat protection purposes, the detected threat level of Windows 10 devices with compatible version and license needs to be "low" or "secured".
This policy may only be disabled on a per-device basis and with explicit approval by corporate security.

### Settings

#### Device Health

	| NAME                                | VALUE                                |
	|-------------------------------------|--------------------------------------|
	| Require the device to be at or...   | low                                  |

### Actions for noncompliance

	| ACTION                   | SCHEDULE | TEMPLATE          | ADD. RECIPIENTS                              |
	|--------------------------|---------:|-------------------|----------------------------------------------|
	| Mark device noncompliant |      0 d | n/a               | DGC_COMPLIANCE_WARNING, DGC_COMPLIANCE_ERROR |
	| Send email to user       |      0 d | MSG-W10-THRDLVL_00|                                              |

*******************************************************************************


2. Assignments
--------------

### Include
1. All Users (predefined / from dropdown menu)

### Exclude
1. AAD_MDM Compliance Exclusion: Thread Level
