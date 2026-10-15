# Security Policy

## Supported Versions

As IPLS is an active academic engineering project under development, only the latest release and the current `main` branch receive security patches.

| Version | Supported |
| ------- | :-------: |
| `main`  |    ✅     |
| < 0.1   |    ❌     |

## Reporting a Vulnerability

We take the security of IPLS seriously. If you discover a security vulnerability, configuration flaw, or potential exploit path within our profile, kernel baseline, or tooling, please follow these guidelines:

1. **Do Not Open a Public Issue**: Publicly disclosing a vulnerability exposes users before a mitigation is available.
2. **Submit via GitHub Security Advisory**:
   - Navigate to the **Security** tab of this repository.
   - Click on **Report a vulnerability** to open a confidential discussion draft.
   - Alternatively, contact the maintainers directly via academic email.
3. **Details to Include**:
   - Description of the flaw and affected components (`airootfs`, `sysctl`, kernel flags, or Rust binaries).
   - Proof of Concept (PoC) or reproduction steps.
   - Potential impact on system amnesia or attack surface.

We will review the report, discuss necessary fixes in private, and issue a patch alongside proper security advisories.
