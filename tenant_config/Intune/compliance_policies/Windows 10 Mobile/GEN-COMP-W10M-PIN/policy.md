Compliance policy name: GEN-COMP-W10M-PIN
===============================================


1. Properties
-------------

### Description
For threat protection purposes, Windows 10 mobile devices need to a PIN code set.
This policy may only be disabled on a per-device basis and with explicit approval by corporate security.

### Settings

#### System Security

	| NAME                                | VALUE                                |
	|-------------------------------------|--------------------------------------|
	| Require a password to unlock...     | require                              |
	| Simple passwords                    | block                                |
	| Password type                       | alphanumeric                         |
	| Number of non-alphanumeric char...  | 1                                    |
	| Minimum password length             | 6                                    |
	| Maximum minutes of inactivity...    | 10                                   |
	| Number of previous passwords to...  | 5                                    |
	| Require password when device ret... | require                              |

### Actions for noncompliance

	| ACTION                   | SCHEDULE | TEMPLATE          | ADD. RECIPIENTS        |
	|--------------------------|---------:|-------------------|------------------------|
	| Mark device noncompliant |      0 d | n/a               |                        |
	| Send email to user       |      0 d | MSG-W10M-PIN_00   |                        |

*******************************************************************************


2. Assignments
--------------

### Include
1. All Users (predefined / from dropdown menu)

### Exclude
1. AAD_MDM Compliance Exclusion: Password
