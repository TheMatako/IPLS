# State of the Art — The Linux Universe, Seen from IPLS

A survey of the Linux ecosystem (distributions, security-oriented systems, and underlying technologies), evaluated against the operational requirements of **IPLS (ISIMA Purple Linux System)**.

This document is a **survey and evaluation only**. Concrete build configurations, manifests, and runtime implementation procedures belong in dedicated project documentation.

---

## Table of contents

0. [Scope and evaluation criteria](#0-scope-and-evaluation-criteria)
1. [Linux genealogy (context)](#1-linux-genealogy-context)
2. [Choosing a base distribution](#2-choosing-a-base-distribution)
3. [Security-oriented systems, by approach](#3-security-oriented-systems-by-approach)
4. [Underlying technologies, by theme](#4-underlying-technologies-by-theme)
5. [Synthesis](#5-synthesis)
6. [References and primary sources](#6-references-and-primary-sources)

---

## 0. Scope and evaluation criteria

**IPLS in one line:** an Arch-based, hardened, reproducible environment bundling Red Team and Blue Team tools for ISIMA students, supporting a lightweight live USB medium, a persistent operating system installation, and memory-safe Rust components.

Every architectural option is benchmarked against eight core criteria:

| ID | Criterion | What it means for IPLS |
| --- | --- | --- |
| **C1** | Minimal attack surface | Curated packages, zero unneeded daemons, drop-by-default exposure. |
| **C2** | Light and fast | Low memory footprint, optimized binary size, rapid boot time. |
| **C3** | Kernel and userland hardening | Self-protecting kernel, memory allocators, syscall restriction. |
| **C4** | Amnesia & ephemeral execution | Stateless live USB runtime, complemented by an on-demand volatile RAM shell in installed mode. |
| **C5** | Purple toolset | Balanced coverage of offensive (Red) and defensive/forensic (Blue) tools. |
| **C6** | Reproducibility | Deterministic pipelines, pinned repositories, and auditable manifests. |
| **C7** | Memory safety / Rust | Proactive mitigation of memory corruption via Rust tools and custom modules. |
| **C8** | Maintainability | Sustainable for a two-student engineering project over 120 hours. |

### Annotation legend

| Tag | Evaluation level | Definition |
| --- | --- | --- |
| ✅ **Keep** | Selected for IPLS | Architecture, tool, or design choice integrated directly into IPLS. |
| 🔶 **Inspire** | Reference source | Valuable pattern borrowed or adapted partially. |
| ❌ **Avoid** | Discarded | Incompatible with IPLS constraints (rationale provided). |
| ℹ️ **Context** | Background | Informational context, no direct adoption. |

**Out of scope:** Consumer desktop workloads (office suites, multimedia playback, gaming), mobile platforms, and hypervisor-level Xen virtualization. IPLS remains focused on security and network engineering, whether booted as a live appliance or installed on dedicated hardware.

---

## 1. Linux genealogy (context)

Operating system lineage dictates package management, initialization schemes, and administrative security practices.

### 1.1 Prehistory (1992)

| System | Historical significance |
| --- | --- |
| **MCC Interim Linux** | First functional Linux distribution delivered with a structured install process. |
| **SLS (Softlanding Linux System)** | Common ancestor: Slackware fixed its defects. Debian was founded in reaction to its instability. |
| **Yggdrasil** | First distribution shipped on CD-ROM, conceptual ancestor of live plug-and-play media. |

### 1.2 Founding lineages

| Lineage | Year | Core characteristics | Notable descendants | IPLS verdict |
| --- | --- | --- | --- | --- |
| **Slackware** | 1993 | Plain tarballs, manual dependencies, BSD-style init. | Early SUSE. | ℹ️ Architectural ancestor. Lacks modern automated packaging. |
| **Debian** | 1993 | `.deb` (`dpkg`/`apt`), strict community governance, stable freeze cycles. | Ubuntu, Kali, Parrot, Tails, Whonix, Kicksecure, Devuan, VyOS. | 🔶 Primary inspiration for security tooling.</br>❌ base discarded (slower toolchain). |
| **Red Hat** | 1994 | `.rpm` (`rpm`/`dnf`), corporate ecosystem, mandatory SELinux. | Fedora, RHEL, CentOS Stream, Rocky, Alma, SUSE (via RPM/zypper). | 🔶 Reference for enterprise MAC and atomic images.</br>❌ base discarded. |
| **Gentoo** | 2000 | Source-based (`Portage`), modular compile flags (USE flags). | ChromiumOS, Funtoo, Hardened Gentoo, Pentoo, CLIP OS. | 🔶 Pioneer of kernel/userland hardening.</br>❌ compile overhead unsustainable. |
| **CRUX → Arch** | 2002 | Binary rolling release, KISS philosophy, FHS-compliant (`pacman`). | Manjaro, EndeavourOS, BlackArch, Athena OS, SteamOS 3. | ✅ **Selected foundation for IPLS.** |
| **Alpine** | 2005 | musl libc, BusyBox, OpenRC, `apk` packaging. | postmarketOS, minimal container base images. | 🔶 Minimalism model.</br>❌ broken glibc compatibility with cyber tools. |
| **Void** | 2008 | Independent codebase, `runit`, `xbps`, dual glibc/musl support. | — | ❌ Smaller software ecosystem than Arch without structural advantage. |
| **NixOS / Guix** | 2003 / 2012 | Functional declarative store, cryptographic isolation. | Guix System. | 🔶 Reproducibility reference.</br>❌ non-FHS path structure breaks third-party binaries. |
| **Android / AOSP** | 2008 | Linux kernel with non-GNU userland (Bionic libc, ART sandbox). | GrapheneOS. | 🔶 Practical lessons in memory mitigation and hardened allocation. |

### 1.3 Meta-build frameworks and niche independents

| System | Analysis |
| --- | --- |
| **Linux From Scratch (LFS)** | Educational reference book for manual construction, not an operational distribution. |
| **Yocto / OpenEmbedded / Buildroot** | Industrial cross-compilation toolchains for embedded devices, excessive overhead for an operational cyber toolkit. |
| **Clear Linux (Intel)** | Stateless filesystem architecture (`/usr` distinct from `/etc`); abandoned upstream in late 2024 / 2025. |
| **Solus, KaOS, Source Mage** | Specialized desktop or niche source models without relevant security tooling ecosystems. |

### 1.4 General desktop derivatives

❌ Derivatives focused on end-user desktop environments (Linux Mint, Pop!_OS, Zorin, elementary OS, Manjaro, EndeavourOS, Garuda) are discarded. Their focus on graphical convenience, display managers, and gaming optimizations directly contradicts **C1** (minimal attack surface) and **C2** (lightweight footprint).

---

## 2. Choosing a base distribution

### 2.1 Comparative matrix

| Base candidate | Package freshness (C8) | Cyber package ecosystem (C5) | Live build engine (C4, C2) | Reproducibility (C6) | Security hardening ecosystem (C3) | Decision |
| --- | --- | --- | --- | --- | --- | --- |
| **Arch Linux** | Continuous rolling release, current LLVM / Rust. | Extensive (Official repos + BlackArch PKGBUILDs / AUR). | Declarative `archiso` engine, proven by SystemRescue. | Verified via Arch Linux Archive (ALA) and `SOURCE_DATE_EPOCH`. | Official `linux-hardened` package. AppArmor and Landlock native. | ✅ **Selected base** |
| **Debian** | Frozen releases, testing/sid unstable. | Massive native cyber ecosystem (Kali upstream). | `live-build` (flexible but brittle and script-heavy). | Mature project-wide reproducible build framework. | Comprehensive (Tails, Kicksecure, AppArmor defaults). | 🔶 Hardening reference.</br>❌ Discarded as base. |
| **Fedora / Atomic** | 6-month cycle, bleeding edge. | Good standard tools, limited offensive packaging. | OCI container layering (`bootc` / `ostree`). | Partial container manifest reproducibility. | High default hardening (SELinux, Secureblue recipes). | 🔶 Immutability reference.</br>❌ Excessive runtime footprint. |
| **Alpine** | Pinned point releases. | Very restricted cyber toolset, musl breaks tools. | Lightweight ISO generation. | High container-level reproducibility. | Default SSP, PIE, and ASLR compilation. | 🔶 Reference for size.</br>❌ glibc dependency breakage. |
| **Gentoo** | Continuous rolling release. | Broad source-based tree. | Complex live image compilation. | Deterministic compile flags, slow pipeline. | Historical foundation of PaX/grsecurity and SSP. | 🔶 Historical reference.</br>❌ CI/CD build times exceed project scope. |
| **NixOS** | Continuous channel updates. | Growing cyber toolset. | Native image generators. | Absolute mathematical determinism. | Hardening supported via declarative modules. | 🔶 Benchmark for C6.</br>❌ Non-standard FHS layout breaks testing. |

### 2.2 Arch Linux: advantages and documented tradeoffs

**Technical advantages:**

- **Rolling release model:** Immediate access to current upstream Linux kernels and modern Rust compiler toolchains, removing the need for manual backporting.
- **KISS philosophy:** Delivers an empty canvas; zero pre-enabled network daemons, display managers, or background telemetries.
- **Modern declarative build tooling:** `archiso` enables programmatic, version-controlled generation of live media with native SquashFS compression and RAM OverlayFS mounting.
- **Official hardened kernel:** The `linux-hardened` package provides an officially maintained kernel carrying self-protection patches and restrictive defaults.

**Documented limitations and mitigations:**

- *Rolling updates can introduce regressions:* Mitigated by locking build dependencies to point-in-time snapshots using the **Arch Linux Archive (ALA)**.
- *Absence of official LTS security errata:* Monitored using automated vulnerability audits (`arch-audit`).
- *No native enterprise SELinux integration:* Mitigated by using **AppArmor** and **Landlock** for mandatory access control and process sandboxing.
- *No dedicated CIS Benchmark for Arch:* Hardening verified against the generic CIS Linux Benchmark and **ANSSI BP-028** recommendations.

---

## 3. Security-oriented systems, by approach

### 3.1 Offensive distributions

| System | Base | Architecture summary | IPLS evaluation |
| --- | --- | --- | --- |
| **Kali Linux** | Debian Testing. | Hundreds of offensive tools. Custom kernel patches for wireless injection. Zero host-level defensive hardening. | 🔶 Reference for standard tool selection (C5).</br>❌ Huge attack surface, large image size, excess daemons (C1, C2). |
| **Parrot OS** | Debian. | Hybrid pentest platform. Incorporates Firejail sandbox wrapping and AnonSurf routing. | 🔶 Highlights sandboxing trade-offs.</br>❌ Heavy desktop overhead, unhardened core (C1, C2). |
| **BlackArch** | Arch Linux | Unfiltered repository of 2,800+ penetration testing tools; full ISO exceeds 22 GB; standard vanilla kernel | ✅ **Source for tool PKGBUILDs**.</br>🔶 Confirms `archiso` scalability.</br>❌ Monolithic ISO size violates C1 and C2 |
| **Athena OS** | Arch Linux | Security training system integrated with Hack The Box; rich graphical desktop environments | 🔶 **Direct counterpart on the Arch base**; prioritizes graphical ergonomics over defensive hardening |
| **Pentoo** | Gentoo | Hardened live environment merging Gentoo Hardened patches with wireless auditing tools | 🔶 **Direct historical precedent for IPLS**. ❌ Inactive due to Gentoo compilation maintenance costs |

### 3.2 Amnesic and privacy platforms

| System | Base | Architecture summary | IPLS evaluation |
| --- | --- | --- | --- |
| **Tails** | Debian | Amnesic system operating entirely from RAM; strict Netfilter rules enforce all egress traffic through Tor | ✅ Primary reference for memory amnesia and default-drop network posture (C4). ❌ Tor routing breaks local subnet auditing |
| **TENS** | Proprietary Linux base | Developed by the US Department of Defense; boots from read-only media directly into RAM on untrusted hosts | ✅ Validates the operational model: an amnesic live OS safely transforms untrusted client hardware into a clean endpoint |

### 3.3 Host-hardening systems

| System | Base | Architecture summary | IPLS evaluation |
| --- | --- | --- | --- |
| **Kicksecure** | Debian | Hardened userland featuring `hardened_malloc`, aggressive sysctl profiles, `/proc` hidepid restrictions, and LKRG | ✅ **Core reference for userland hardening recipes** (C3). ❌ Debian desktop orientation |
| **Secureblue** | Fedora Atomic | Immutable bootc/ostree appliance; read-only root, enforcing SELinux, hardened kernel arguments, Flatpak isolation | ✅ Blueprint for immutability combined with hardening. ❌ Desktop-centric design |
| **Hardened Gentoo** | Gentoo | Historical pioneer of PaX/grsecurity integration, global Stack Smashing Protection, and PIE userland defaults | 🔶 Conceptual foundation for contemporary Linux self-protection initiatives |
| **GrapheneOS** | AOSP | Leading hardened mobile operating system; creator of `hardened_malloc`, fine-grained memory layout randomizations | ✅ Source for memory corruption mitigation strategies (C3, C7) |
| **Astra Linux** | Debian | Certified for defense sectors; features a proprietary kernel-level mandatory access control module (PARSEC) | ℹ️ Specialized architectural implementation of military-grade MAC |

### 3.4 Compartmentalization and infrastructure OS

| System | Architecture summary | IPLS evaluation |
| --- | --- | --- |
| **Qubes OS** | Xen Type-1 bare-metal hypervisor compartmentalizing network (`sys-net`), storage, and apps into distinct VMs | 🔶 Industry benchmark for compartmentalization. ❌ Requires substantial hardware; unsuitable for a live USB appliance (C2, C8) |
| **CLIP OS** | Dual-compartment architecture (low/high trust) designed by the ANSSI; hardened kernel patches | 🔶 Landmark French government reference; project frozen/inactive since 2022 |
| **Bottlerocket** | Minimal container-host OS by AWS; verified read-only root, dm-verity, strict SELinux, **userland built primarily in Rust** | ✅ **Industrial validation that a security-focused, Rust-centric immutable OS is practical** (C7) |

### 3.5 Forensics, response, and rescue

| System | Base | Architecture summary | IPLS evaluation |
| --- | --- | --- | --- |
| **SystemRescue** | Arch Linux | Minimal administrative live USB; successfully transitioned from Gentoo to Arch Linux and `archiso` | ✅ Industrial proof that `archiso` maintains a dependable, lightweight live recovery system (C8) |
| **SIFT Workstation** | Ubuntu | Industry-standard toolkit for Digital Forensics and Incident Response (DFIR) | 🔶 Primary reference for Blue Team analysis tool curation (C5) |
| **CAINE / Tsurugi** | Ubuntu | Forensic live environments; strict write-blocking policy preventing auto-mounting of connected physical drives | ✅ Critical forensic pattern retained: suspect drives must never auto-mount with write permissions |

### 3.6 Specialized network platforms

| System | Base / Core | Architecture summary | IPLS evaluation |
| --- | --- | --- | --- |
| **VyOS** | Debian | Appliance operating strictly through a specialized network configuration CLI | 🔶 Model for headless, minimal, CLI-focused systems |
| **OPNsense / pfSense** | FreeBSD | Dedicated stateful firewall and routing distributions | ℹ️ Reference for isolated network appliances |
| **Stormshield SNS** | FreeBSD | ANSSI-certified industrial firewall embedding proprietary ASQ inspection engines into the BSD kernel stack | ℹ️ Industry benchmark for certified network filtering |
| **OpenWrt** | Minimal Linux | Embedded operating system using BusyBox and lightweight netifd | ℹ️ Architecture reference for ultra-low footprint routing |

### 3.7 Non-Linux security benchmarks

| System | Core innovations | IPLS evaluation |
| --- | --- | --- |
| **OpenBSD** | Proactive security design; default $W\oplus X$ memory enforcement, ASLR, explicit capability restriction (`pledge()`, `unveil()`) | 🔶 Conceptual benchmark; mirrored on Linux using seccomp-bpf, Landlock, and strict kernel permissions |
| **HardenedBSD** | Hardened FreeBSD fork featuring elevated ASLR entropy and compile-time exploit mitigations | ℹ️ Alternative approach to memory corruption mitigation |

---

## 4. Underlying technologies, by theme

### 4.1 Kernel self-protection lineage

| Project / Component | Scope and technical implementation | IPLS status |
| --- | --- | --- |
| **PaX / grsecurity** | Pioneered kernel memory protections, structural layout randomization, and memory protections in the early 2000s; closed to a commercial model in 2017 | ℹ️ Origin of modern hardening techniques; ❌ non-distributable |
| **KSPP** (Kernel Self-Protection Project) | Coordinated initiative led by Kees Cook to port proactive defenses into upstream mainline Linux | ✅ Authoritative technical reference for kernel configuration |
| **linux-hardened** | Community-maintained Arch package implementing out-of-tree hardening patches (SLAB freelist defenses, restricted sysctl defaults) | ✅ **Baseline kernel for IPLS** (C3) |
| **LKRG** (Linux Kernel Runtime Guard) | Openwall kernel module performing runtime integrity validation of kernel code and credential structures | 🔶 Studied for integrity monitoring; evaluated against stability constraints |
| **kernel-hardening-checker** | Automated audit script evaluating `.config` parameters and kernel boot arguments against KSPP recommendations | ✅ Selected scoring tool for before/after pipeline verification |

### 4.2 Security baselines and audit frameworks

- **ANSSI BP-028:** French national guidelines for securing GNU/Linux environments (Minimum, Intermediate, and Enhanced levels).
- **CIS Benchmarks:** Industry-standard configuration benchmarks; evaluated using the Distribution-Independent Linux baseline.
- **Audit Tooling:** Integrated execution of **Lynis** and **OpenSCAP** within testing workflows to measure hardening scores.

### 4.3 Access control and isolation primitives

| Mechanism | Architecture | IPLS integration |
| --- | --- | --- |
| **AppArmor** | Path-based Mandatory Access Control (LSM); intuitive profile definitions | ✅ Pragmatic fit for targeted daemon confinement on Arch Linux |
| **Landlock** | Unprivileged LSM enabling applications to safely restrict their own filesystem access | ✅ Integrated into in-house Rust utility tools for self-sandboxing |
| **Yama** | LSM controlling process tracing (`ptrace_scope`) | ✅ Enabled to prevent unauthorized memory inspection across userland |
| **SELinux** | Label-based Mandatory Access Control | ❌ Avoided due to filesystem labeling complexity on live media |
| **seccomp-bpf** | Syscall filtering mechanism restricting the kernel attack surface accessible to userland binaries | ✅ Enforced across security-critical custom utilities |

### 4.4 Memory safety and Rust integration

#### Industry vulnerability context

Comprehensive reports from Microsoft (MSRC), Google (Chromium and Android projects), and advisory bodies (NSA, CISA) confirm that **approximately 70 % of identified critical security vulnerabilities stem from memory safety bugs** (buffer overflows, Use-After-Free, double frees, out-of-bounds writes).

#### Rust in the kernel (Rust for Linux)

- Formally integrated into mainline Linux beginning with release 6.1 under Miguel Ojeda's lead.
- Downstream hardware implementations include the AX88796B Ethernet PHY driver, Android Binder subsystems, and experimental DRM drivers.
- *Technical constraints:* Rust-for-Linux abstractions for the core networking stack remain under active development. Direct kernel interfacing still mandates explicit `unsafe` blocks when communicating with raw hardware registers.

#### Rust in userland infrastructure

Adoption in critical systems is established by AWS **Bottlerocket**, the Android system services, `sudo-rs`, and modern utilities like `ripgrep`.

**IPLS Architectural Decision for Rust:**

1. **Tool replacement and ecosystem curation:** Replace aging, memory-unsafe C userland binaries with proven, performant Rust alternatives (e.g., `ripgrep` replacing `grep`, `eza` replacing `ls`, `sniffnet`/`trippy` for network analysis, `feroxbuster` for web fuzzing).
2. **In-house userland engineering:** Build lightweight, specialized cyber auditing tools in safe Rust, sandboxed natively with **Landlock** and **seccomp**.
3. **Kernel-level evaluation:** Implement a targeted Proof-of-Concept Loadable Kernel Module (LKM) in Rust to demonstrate memory-safe kernel programming without destabilizing the core network stack.
4. **Hardened allocation:** Protect remaining compiled C userland binaries using `hardened_malloc`.

### 4.5 Dual deployment architecture and ephemeral RAM isolation

IPLS balances quick live engagements with persistent workstation workflows through two complementary deployment models:

#### 1. Live USB model (Lightweight and amnesic)

- **Compressed base (SquashFS):** Contains the minimal operating system root in read-only format.
- **Volatile overlay (OverlayFS + tmpfs):** Directs all filesystem writes into RAM. Powering off drops the memory state, preventing persistent storage contamination.

#### 2. Installed OS model with on-demand volatile execution (Approach B)

When installed permanently on disk (for lab work and continuous training), IPLS provides an instant, on-demand volatile RAM mode without requiring a system reboot:

- **Mount namespaces (`unshare -m`):** Creates an isolated mount table distinct from the host system.
- **In-memory OverlayFS session:** Overlays the persistent root with an ephemeral `tmpfs` upper directory.
- **Immediate cleanup:** Commands run within this sandboxed sub-shell leave no writes on physical disk partitions; exiting the shell automatically unmounts the overlay and frees RAM buffers.

### 4.6 Trusted boot and image integrity

- **Unified Kernel Images (UKI):** Consolidates the kernel executable, initramfs, and kernel command-line arguments into a single UEFI PE binary for secure signing.
- **Cryptographic Verification:** Verification using `dm-verity` prevents runtime tampering with the underlying SquashFS layer.
- **Module Signing:** Enforce `CONFIG_MODULE_SIG_FORCE` to block unauthorized out-of-tree kernel modules.

### 4.7 Build automation and reproducible pipelines

- **Build Engine:** `archiso` serves as the primary declarative build pipeline, maintaining configuration scripts directly in Git.
- **Reproducible Builds Framework:** Enforce the `SOURCE_DATE_EPOCH` specification across the build environment to standardize file timestamps.
- **Snapshot Determinism:** Package sources are pinned to specific dates using the **Arch Linux Archive (ALA)**, ensuring identical package states across rebuilds.

---

## 5. Synthesis

### 5.1 Comprehensive comparison against IPLS criteria

**Legend:**

- 🟢 **Strong:** Criterion is a primary design goal, fully implemented and enforced.
- 🟡 **Partial:** Criterion is partially addressed, optional, or mitigated with compromises.
- 🔴 **Absent:** Criterion is unaddressed, out of scope, or violated by design.

| System | C1 Surface | C2 Light | C3 Hardening | C4 Amnesia | C5 Purple tools | C6 Repro. | C7 Rust / Mem. safety | C8 Maintainable |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Offensive toolboxes** | | | | | | | | |
| Kali Linux | 🔴 | 🔴 | 🔴 | 🟡 | 🟢 | 🔴 | 🔴 | 🟢 |
| Parrot OS | 🔴 | 🔴 | 🟡 | 🟡 | 🟢 | 🔴 | 🔴 | 🟢 |
| BlackArch | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 | 🔴 | 🔴 | 🟡 |
| Athena OS | 🔴 | 🔴 | 🔴 | 🔴 | 🟢 | 🔴 | 🔴 | 🟡 |
| Pentoo | 🟡 | 🟡 | 🟡 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| **Amnesic & Hardened** | | | | | | | | |
| Tails | 🟢 | 🟡 | 🟢 | 🟢 | 🔴 | 🟢 | 🔴 | 🟢 |
| TENS | 🟢 | 🟢 | 🟡 | 🟢 | 🔴 | 🟡 | 🔴 | 🟡 |
| Kicksecure | 🟢 | 🟡 | 🟢 | 🔴 | 🔴 | 🟡 | 🔴 | 🟢 |
| Secureblue | 🟢 | 🔴 | 🟢 | 🔴 | 🔴 | 🟡 | 🔴 | 🟡 |
| **Isolation & Cloud** | | | | | | | | |
| Qubes OS | 🟢 | 🔴 | 🟢 | 🔴 | 🟡 | 🔴 | 🔴 | 🟡 |
| CLIP OS | 🟢 | 🟡 | 🟢 | 🔴 | 🔴 | 🟡 | 🔴 | 🔴 |
| Bottlerocket | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🟡 | 🟢 | 🟡 |
| **Rescue & Forensics** | | | | | | | | |
| SystemRescue | 🟡 | 🟢 | 🔴 | 🟢 | 🟡 | 🟡 | 🔴 | 🟢 |
| CAINE / Tsurugi | 🔴 | 🔴 | 🔴 | 🟡 | 🟡 | 🔴 | 🔴 | 🟡 |
| **Project Target** | | | | | | | | |
| **IPLS** | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 | 🟡 | 🟢 | 🟡 |

### 5.2 Identified gaps in the contemporary ecosystem

The analysis reveals clear structural divides across the security landscape:

1. **Offensive systems ignore defensive hygiene:** Tool distributions (Kali, BlackArch) ship extensive arsenals (C5) while tolerating unhardened kernels, bloated userlands, and wide-open attack surfaces (C1, C3).
2. **Hardened platforms omit offensive and analysis toolsets:** Hardened systems (Kicksecure, Secureblue) prioritize defensive self-protection but lack cyber utility packages.
3. **Amnesic distributions prioritize anonymity over lab work:** Tails enforces amnesia and network control (C4), but forces all traffic through Tor, making local subnet analysis and active testing impossible.
4. **Memory safety is rare in specialized distributions:** Modern language adoption (Rust) is proven in enterprise cloud hosts (Bottlerocket) but has not been applied to custom live security appliances.

### 5.3 Technical positioning of IPLS

IPLS targets this gap by integrating proven methods across six areas:

- **Base OS and build toolchain:** Derived from **Arch Linux** and built with **`archiso`**, mirroring the maintainability of **SystemRescue**.
- **System hardening profiles:** Adopting sysctl configurations, module restrictions, and `hardened_malloc` patterns from **Kicksecure** and **Secureblue**.
- **Kernel baseline:** Configured around **`linux-hardened`** and upstream **KSPP** standards.
- **Amnesic and ephemeral execution:** Implementing the read-only SquashFS architecture for live boot alongside an in-memory namespace shell (Approach B) for volatile test sessions on disk.
- **Forensic hygiene:** Applying write-blocking policies for connected local media inspired by **CAINE**.
- **Proactive memory safety:** Curating native Rust replacements for vulnerable legacy tools while developing custom utilities protected with **Landlock** self-sandboxing.

---

## 6. References and primary sources

*All online sources verified and accessed as of October 2026.*

### Specifications and standards

- **ANSSI BP-028 (v2.0):** *Recommandations de sécurité relatives à un système GNU/Linux* — Agence Nationale de la Sécurité des Systèmes d'Information.
- **CIS Benchmarks:** *CIS Distribution Independent Linux Benchmark v2.1.0* — Center for Internet Security.
- **Reproducible Builds Project:** *Deterministic compilation specifications and SOURCE_DATE_EPOCH* — reproducible-builds.org.
- **Software Package Data Exchange (SPDX):** *Specification v2.3* — Linux Foundation.

### Kernel architecture and hardening

- **Kernel Self-Protection Project (KSPP):** Kees Cook et al. — kernsec.org/wiki/index.php/Kernel_Self_Protection_Project.
- **kernel-hardening-checker:** Alexander Popov — github.com/a13xp0p0v/kernel-hardening-checker.
- **Arch Linux `linux-hardened`:** Package build recipes and patch sets — gitlab.archlinux.org/archlinux/packaging/packages/linux-hardened.
- **Rust for Linux (RfL):** Official kernel documentation and tree (`Documentation/rust/`) — rust-for-linux.com.
- **Linux Kernel Runtime Guard (LKRG):** Openwall Project — openwall.com/lkrg/.

### Operating systems and hardening projects

- **Kicksecure Documentation:** Host hardening, memory allocator integration, and process isolation — kicksecure.com.
- **Secureblue Repository:** Hardened immutable Fedora Atomic images — github.com/secureblue/secureblue.
- **Tails Specification:** Design documentation and amnesic live model — tails.net/contribute/design/.
- **GrapheneOS:** `hardened_malloc` implementation — github.com/GrapheneOS/hardened_malloc.
- **AWS Bottlerocket:** Architecture and Rust implementation — github.com/bottlerocket-os/bottlerocket.
- **SystemRescue Manual:** Migration to Archiso and maintenance model — system-rescue.org.
- **BlackArch Linux:** Package database and PKGBUILD repositories — blackarch.org.
- **Qubes OS Architecture:** *Architecture Next Steps: The Xen Hypervisor Isolation Model* — qubes-os.org.

### Vulnerability research and memory safety

- **Microsoft Security Response Center (MSRC):** *A proactive approach to more secure code* (G. Thomas) — msrc.microsoft.com/blog.
- **Chromium Project Security:** *Memory safety bug statistics* — chromium.googlesource.com.
- **CISA / NSA Joint Guidance:** *The Case for Memory Safe Roadmaps* — cisa.gov.
- **National Vulnerability Database (NVD):** Common Vulnerabilities and Exposures (CVE-2024-3094, kernel UAF reports) — nvd.nist.gov.
