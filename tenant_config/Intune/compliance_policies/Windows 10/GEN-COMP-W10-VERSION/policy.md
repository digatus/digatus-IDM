Compliance policy name: GEN-COMP-W10-VERSION-MIN
================================================


1. Properties
-------------

### Description
To ensure compatibility and maintainability of Windows 10 devices, a minimum version is enforced.
This policy may only be disabled on a per-device basis and with explicit approval by corporate security.

### Settings

#### Device Properties

	| NAME                                | VALUE                                |
	|-------------------------------------|--------------------------------------|
	| Minimum OS version                  | 10.0.16299                           |
	| Minimum OS version for mobile dev...| 10.0.15254                           |

### Actions for noncompliance

	| ACTION                   | SCHEDULE | TEMPLATE           | ADD. RECIPIENTS        |
	|--------------------------|---------:|--------------------|------------------------|
	| Send email to user       |      0 d | MSG-W10-VERSION_00 |                        |
	| Send email to user       |      7 d | MSG-W10-VERSION_07 |                        |
	| Send email to user       |     14 d | MSG-W10-VERSION_14 | DGC_COMPLIANCE_WARNING |
	| Send email to user       |     21 d | MSG-W10-VERSION_21 |                        |
	| Send email to user       |     28 d | MSG-W10-VERSION_28 |                        |
	| Send email to user       |     30 d | MSG-W10-VERSION_30 | DGC_COMPLIANCE_ERROR   |
	| Mark device noncompliant |     30 d | n/a                |                        |

*******************************************************************************


2. Assignments
--------------

### Include
1. All Users (predefined / from dropdown menu)

### Exclude
1. AAD_MDM Compliance Exclusion: OS Version
