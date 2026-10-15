# Repository Security & Forge Governance

This document establishes the security baselines, supply chain defenses, and automated vulnerability management mechanisms enforced on the **IPLS (ISIMA Purple Linux System)** repository.

Operating under the DevSecOps principle of **Shift-Left Security**, potential configuration vulnerabilities, malicious upstream dependencies, and credential leaks are detected, mitigated, or blocked before reaching the codebase.

---

## 1. Vulnerability Intake & Responsible Disclosure

IPLS enforces a coordinated vulnerability disclosure workflow to prevent zero-day exposure in public tracking channels.

```text
[ Discovery ] ──► [ Private Report ] ──► [ Secure Remediation ] ──► [ Public Advisory ]
  (Researcher)       (Encrypted Inbox)       (Draft Workspace)        (Published CVE)
```

### 1.1 Private Vulnerability Reporting

- **Configuration:** **Enabled**
- **CWE Requirement:** **Disabled** (Minimizes reporting friction for students and external researchers; vulnerability taxonomy is classified during maintainer triage).
- **Rate Limiting:** Capped at **10 advisories per day** as an anti-spam / DoS prevention measure against maintainer review queues.
- **Workflow:** Security issues are submitted through GitHub's confidential advisory interface. Triage, impact evaluation, and patch preparation occur in a private draft space isolated from public repository issues.

### 1.2 Security Policy (`SECURITY.md`)

- A root-level [`SECURITY.md`](../SECURITY.md) defines supported release versions and responsible disclosure guidelines.

### 1.3 Public Security Advisories

- Once a patched increment is verified and merged into `main`, maintainers publish an official **GitHub Security Advisory** detailing the CVE identification, affected scopes, and upgrade instructions.

---

## 2. Software Supply Chain Security

Compromising upstream build tooling or system libraries threatens the cryptographic integrity of the compiled IPLS ISO. The repository implements multi-layered dependency governance:

| Protection Mechanism | Status | Operational Role |
| --- | :---: | --- |
| **Dependency Graph** | **Enabled** | Maps all build-time manifests, GitHub Actions workflow dependencies, and native Rust crates. |
| **Dependabot Alerts** | **Enabled** | Correlates tracked dependencies against the GitHub Advisory Database for active CVEs. |
| **Malware Alerts** | **Enabled** | Alerts maintainers if upstream dependencies or actions are flagged as malicious code or supply chain compromises. |
| **Dependabot Security Updates** | **Enabled** | Automatically generates minimal Pull Requests targeting `main` when upstream patches become available. |
| **Dependabot Version Updates** | **Configured** | Automates non-breaking weekly version upgrades defined in `.github/dependabot.yml`. |
| **Auto-Triage Presets** | **Standard** | Filters out low-impact alerts on non-production development scopes while ensuring malware detections are never dismissed automatically. |

---

## 3. Secret Protection & Push Verification

Accidental leaks of laboratory credentials, private SSH keys, or access tokens into a public Git history pose immediate threats to our physical and virtual infrastructure.

### 3.1 Push Protection Engine

- **Status:** **Enabled**
- **Mechanism:** Continuous scanning acts as a pre-receive hook on GitHub endpoints.
- **Behavior:** If a commit contains a supported credential pattern (e.g., SSH private keys, cloud tokens, API secrets), the server rejects the `git push` execution immediately before writing the commit to the repository history.

---

## 4. Forge Security Gates & Status Checks

While local linting and compilation baselines are enforced via developer pre-flight checks (see [`CONTRIBUTING.md`](../CONTRIBUTING.md)), GitHub's platform gates restrict code promotion on `main`:

- **Failure Thresholds:** Security scan check runs enforce a failure threshold set to **High or higher** for vulnerability severity, and **Only errors** for standard checks.
- **Merge Blocking:** Integrated with branch rulesets (see [`project-management.md`](project-management.md)), unresolved security check failures prevent Pull Requests from merging.
