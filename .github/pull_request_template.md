# Pull Request

## Description

<!-- Provide a clear and concise summary of the changes introduced in this PR. Explain the technical motivation and problem solved. -->

Closes #(issue_number)

---

## Type of Change

<!-- Select the relevant type(s) matching our Conventional Commits specification: -->
- [ ] `feat`: New feature, tool, or capability
- [ ] `fix`: Bug fix or patch
- [ ] `docs`: Documentation addition, update, or diagram
- [ ] `ci`: Pipeline workflows, build runners, or automation scripts
- [ ] `refactor`: Code or configuration restructuring without behavioral change
- [ ] `chore`: Maintenance, repository setup, or dependency updates

---

## Security & Hardening Impact

<!-- Detail how this modification impacts the attack surface or system posture. -->
- **Attack Surface Impact:** <!-- [e.g., Package added / Unneeded daemon masked / Minimal impact] -->
- **Kernel / Sysctl Modifications:** <!-- [e.g., Restricted sysctl parameter applied / N/A] -->
- **Compliance Baseline Reference:** <!-- [e.g., ANSSI BP-028 v2.0 R23, CIS Linux Benchmark 3.1.2, or N/A] -->
- **Network / Firewall Behavior:** <!-- [e.g., New nftables drop rule, interface routing policy, or None] -->

---

## Pre-Flight Checks & Verification

<!-- What tests were run locally to verify these changes? -->
- [ ] Ran local pre-flight checks (`make check` or dedicated component checks)
- [ ] Shell scripts validated with `shellcheck` (zero warnings; POSIX compliant if `/bin/sh`)
- [ ] Rust modules checked (`cargo fmt --check`, `cargo clippy -- -D warnings`, `cargo test`)
- [ ] Archiso build / profile smoke tested locally (if modifying profile definitions)

---

## Contributor Checklist

- [ ] My code and PR description are strictly written in **English**.
- [ ] Commit history adheres to the **Conventional Commits** specification.
- [ ] The associated GitHub Issue is linked and set to `In Progress` on the project board.
- [ ] Corresponding documentation under `docs/` has been created or updated.
- [ ] No hardcoded credentials, SSH private keys, lab passwords, or tokens are committed.
- [ ] Ready for peer review (Four-Eyes Principle).
