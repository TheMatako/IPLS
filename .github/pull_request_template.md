---
name: IPLS Task
about: Standard development, hardening, or documentation task for IPLS
title: '[IPLS TASK] '
labels: enhancement
assignees: ''
---

## 1. Objective & Context
<!-- Describe what needs to be accomplished and why. What technical requirement does this address? -->

## 2. Technical Scope
<!-- Identify the system layer(s) impacted by this task (check all that apply) -->
- [ ] **Kernel & Boot:** Kernel configuration (`linux-hardened`), sysctl parameters, bootloader flags
- [ ] **Archiso Profile:** Base packages (`packages.x86_64`), rootfs overlay (`airootfs/`), build configuration (`profiledef.sh`)
- [ ] **System Hardening:** Firewall policies (`nftables`), access control (`AppArmor`/`Landlock`), service restrictions
- [ ] **Rust Modules:** In-house cyber tooling or memory-safe components (`src/rust/`)
- [ ] **CI/CD & DevOps:** GitHub Actions workflows, build runners, local `Makefile` automation
- [ ] **Documentation:** Technical specifications, architecture surveys, or diagrams under `docs/`

## 3. Proposed Implementation
<!-- Provide a concise summary of the planned technical steps, modified files, or packages to add/remove -->

## 4. Hardening & Security Justification (if applicable)
<!-- If modifying /etc, network filters, or kernel knobs, reference the corresponding security baseline -->
- **Security Baseline:** (e.g., ANSSI BP-028 R23 / CIS Benchmark 2.1.0 / KSPP recommendation)
- **Security Impact:** (e.g., Reduces attack surface by disabling unused protocol / mitigates unprivileged namespace abuse)

## 5. Acceptance Criteria (Definition of Done)
<!-- Check off these criteria to confirm the task is complete before closing the issue -->
- [ ] Local tests and pre-flight checks pass cleanly (`make check`)
- [ ] Dedicated working branch created using GitHub Flow naming conventions (`feat/*`, `fix/*`, `docs/*`, `ci/*`)
- [ ] Conventional Commits applied with imperative English messages
- [ ] Relevant documentation updated or created under `docs/`
- [ ] Pull Request submitted, linking this issue (`Closes #<issue_number>`)
- [ ] Peer review approved by teammate and merged into `main`
