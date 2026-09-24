# IPLS - ISIMA Purple Linux System

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## About The Project

**ISIMA Purple Linux System (IPLS)** is a custom, hardened Linux distribution based on Arch Linux, purpose-built for ISIMA students in Network and Cybersecurity. Developed as a 120-hour academic engineering project, IPLS bridges the gap between offensive operations (Red Team) and defensive mechanisms (Blue Team).

Rather than just bundling existing tools, the core philosophy of IPLS relies on three pillars:
1. **Zero-Trust Hardening:** A minimalist OS built from scratch with a drastically reduced attack surface, utilizing strict network policies and a hardened kernel.
2. **Custom Tooling      :** Native integration of purpose-built security and networking tools developed in **Rust**.
3. **DevSecOps Pipeline  :** A fully automated, version-controlled CI/CD deployment chain using GitHub Actions to build and test the ISO in a reproducible Infrastructure as Code (IaC) manner.

## Who We Are

We are Mateo and Raphael, two engineering students at **ISIMA** (Institut Supérieur d'Informatique, de Modélisation et de leurs Applications) located in Clermont-Ferrand, France. We are specializing in computer science, software engineering, network and cybersecurity. This project serves as our final major academic project, combining our skills in system administration, networking, DevSecOps, and low-level programming.

## Documentation

We believe in the *Doc-as-Code* methodology. Every step required to set up the environment, build the ISO, and understand our security choices is documented. 

You can explore our technical documentation below:
- [Infrastructure Setup: Network, Arch VM and Proxmox Server, Router, IP addresses](docs/network-infrastructure.md)
- *(More documentation will be added here regarding OS Hardening, CI/CD, and Rust Tooling as the project progresses).*

## Contributing

As an open-source project, we welcome community contributions! Whether you want to improve our hardening scripts, add a new Rust-based tool, or simply fix a typo in the documentation, your help is appreciated.

Please refer to our [CONTRIBUTING.md](CONTRIBUTING.md) file for detailed instructions on how to set up your development environment, our coding standards, and the pull request process.

## License

Distributed under the **GNU General Public License v3.0 (GPLv3)**. 

In short, this *copyleft* license guarantees the freedom to run, study, share, and modify the software. It ensures that IPLS remains free and open-source forever: if you modify and distribute this software, you must release your changes under the exact same open-source license.

See the `LICENSE` file in the root directory for the full legal text.