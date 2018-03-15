Compliance policy name: GEN-COMP-W10-ENCRYPTION
===============================================


1. Properties
-------------

### Description
For threat protection purposes, Windows 10 devices need to have their operating system partition encrypted using BitLocker.
This policy may only be disabled on a per-device basis and with explicit approval by corporate security.

### Settings

#### Device Health

	| NAME                                | VALUE                                |
	|-------------------------------------|--------------------------------------|
	| Require BitLocker                   | require                              |

#### System Security

	| NAME                                | VALUE                                |
	|-------------------------------------|--------------------------------------|
	| Encryption of data storage on device| require                              |

### Actions for noncompliance

	| ACTION                   | SCHEDULE | TEMPLATE           | ADD. RECIPIENTS        |
	|--------------------------|---------:|--------------------|------------------------|
	| Send email to user       |      1 d | MSG-W10-ENCRYPT_01 |                        |
	| Send email to user       |      6 d | MSG-W10-ENCRYPT_06 | DGC_COMPLIANCE_WARNING |
	| Send email to user       |     10 d | MSG-W10-ENCRYPT_10 |                        |
	| Send email to user       |     11 d | MSG-W10-ENCRYPT_11 | DGC_COMPLIANCE_ERROR   |
	| Mark device noncompliant |     11 d | n/a                |                        |

*******************************************************************************


2. Assignments
--------------

### Include
1. All Users (predefined / from dropdown menu)

### Exclude
1. AAD_MDM Compliance Exclusion: Encryption
