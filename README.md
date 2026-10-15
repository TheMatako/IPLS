# IPLS - ISIMA Purple Linux System

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Quality Gate](https://github.com/TheMatako/IPLS/actions/workflows/lint.yml/badge.svg)](https://github.com/TheMatako/IPLS/actions/workflows/lint.yml)
[![Base: Arch Linux](https://img.shields.io/badge/Base-Arch_Linux-1793D1.svg?logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Kernel: linux-hardened](https://img.shields.io/badge/Kernel-linux--hardened-orange.svg)](https://gitlab.archlinux.org/archlinux/packaging/packages/linux-hardened)
[![Tooling: Rust](https://img.shields.io/badge/Language-Rust-DEA584.svg?logo=rust&logoColor=white)](https://www.rust-lang.org/)

## About The Project

**ISIMA Purple Linux System (IPLS)** is a custom, hardened Linux operating system based on Arch Linux, purpose-built for engineering students specializing in Network and Cybersecurity at **ISIMA** (Clermont-Ferrand, France). Developed as a 120-hour academic engineering project, IPLS bridges the gap between offensive operations (Red Team) and defensive analysis (Blue Team).

Rather than simply bundling uncurated packages, the development of IPLS is guided by three foundational architectural pillars:

1. **Zero-Trust Hardening (Target Baseline):** Minimizing the attack surface from scratch by stripping unneeded daemons, targeting strict `nftables` default-drop network policies, progressive process confinement (AppArmor, Landlock, seccomp), and the integration of an upstream hardened kernel (`linux-hardened`).
2. **Proactive Memory Safety (Tooling Strategy):** Mitigating memory corruption risks by curating modern **Rust** alternatives to legacy C utilities, developing specialized in-house network tools sandboxed with **Landlock**, and implementing a targeted Rust Loadable Kernel Module (LKM) Proof-of-Concept.
3. **Reproducible DevSecOps (Build Infrastructure):** Managing the operating system profile as Infrastructure as Code (IaC) through declarative `archiso` recipes, continuously validated by local pre-flight checks and automated GitHub Actions pipelines.

---

## Repository Structure

```text
IPLS/
├── .github/                      # Forge automation, CI/CD, and governance
│   ├── ISSUE_TEMPLATE/           # Engineering task issue templates
│   ├── rulesets/                 # Ruleset as Code (main branch protection)
│   ├── workflows/                # GitHub Actions pipelines (Quality Gate & Linters)
│   ├── dependabot.yml            # Automated weekly dependency updates
│   └── pull_request_template.md  # Standardized PR checklist and security justification
├── .vscode/                      # Shared editor settings (markdownlint, format-on-save)
├── docs/                         # Technical documentation and Architecture Decision Records
│   ├── assets/                   # Architecture diagrams and technical schematics
│   ├── network-infrastructure.md # Lab infrastructure, Cisco router, and VM networking
│   ├── project-management.md     # Engineering playbook, ADR, and Kanban governance
│   ├── repository-security.md    # Supply chain security, Dependabot, and push protection
│   └── state-of-the-art.md       # Comparative study of Linux distributions (C1–C8 criteria)
├── .gitignore                    # Exclusions for build artifacts, Rust targets, and credentials
├── .markdownlint.json            # Markdown linting configuration rules
├── CONTRIBUTING.md               # Contribution rules, Conventional Commits, and PR lifecycle
├── LICENSE                       # GNU General Public License v3.0 (GPLv3)
├── Makefile                      # Local pre-flight automation interface (make check)
├── README.md                     # Project overview and documentation index
└── SECURITY.md                   # Vulnerability reporting policy and disclosure SLA
```

---

## Technical Documentation

We enforce the *Documentation-as-Code* methodology. Every technical decision, security baseline, and deployment step is codified under `docs/`:

- **[State of the Art & Architecture Survey](docs/state-of-the-art.md):** Comprehensive analysis of historical and specialized Linux distributions (Kali, BlackArch, Tails, Kicksecure, Bottlerocket) benchmarked against IPLS criteria (C1–C8), kernel self-protection, and memory safety.
- **[Project Management & Engineering Workflow](docs/project-management.md):** Operational playbook detailing GitHub Flow, branch protection rulesets, Kanban lifecycle (GitHub Projects v2), and workspace isolation.
- **[Repository Security & Forge Governance](docs/repository-security.md):** Supply chain defense specifications, Dependabot alerting, secret push protection, and coordinated vulnerability disclosure workflows.
- **[Network & Infrastructure Setup](docs/network-infrastructure.md):** Isolated laboratory setup across Home NAT and School topologies (Cisco 881 router double NAT), Proxmox VE bridge, Arch Linux VM, and OpenSSH remote configuration.
- *(More documentation will be added here as the project progresses).*

---

## Who We Are

We are two engineering students at **ISIMA** (Institut Supérieur d'Informatique, de Modélisation et de leurs Applications) in Clermont-Ferrand, France:

- **Matéo Reymond ([@TheMatako](https://github.com/TheMatako)):** Kernel self-protection, low-level hardening, memory safety / Rust LKM research, DevSecOps pipelines, and repository governance.
- **Raphaël Verginelli ([@RaphaelVerginelli](https://github.com/RaphaelVerginelli)):** Archiso profile definition, userland tool curation, educational documentation, and the interactive `pls` CLI helper.

This project represents our final major academic engineering project, uniting low-level systems programming, networking, and security governance.

---

## Contributing

IPLS follows a strict peer-reviewed workflow (**Four-Eyes Principle**) with linear Git history.

Local scripts, configurations, and documentation must satisfy our automated quality gate before submitting a Pull Request. A root [`Makefile`](Makefile) provides pre-flight checks:

```bash
make check
```

Please refer to [`CONTRIBUTING.md`](CONTRIBUTING.md) for branch naming conventions, Conventional Commit semantics, and the Pull Request protocol.

---

## Security Policy

To report a suspected security vulnerability or configuration flaw, please consult our [`SECURITY.md`](SECURITY.md) policy and submit a confidential advisory via GitHub's Private Vulnerability Reporting channel.

---

## License

Distributed under the **GNU General Public License v3.0 (GPLv3)**.

This copyleft license guarantees the freedom to run, study, share, and modify the software. Any modifications or derivative works must be distributed under the exact same license.

See the [`LICENSE`](LICENSE) file for the full legal text.
