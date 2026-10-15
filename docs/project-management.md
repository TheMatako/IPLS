# Project Management & Engineering Workflow

This document serves as the operational engineering manual and Architecture Decision Record (ADR) for the **IPLS (ISIMA Purple Linux System)** project. It details the day-to-day collaboration framework, technical justifications for the toolchain, repository governance, and task tracking mechanisms.

---

## 1. Operational Philosophy

Rather than relying on speculative upfront schedules, IPLS enforces an **iterative, day-to-day engineering workflow** grounded in DevSecOps principles:

- **Traceability first:** Every technical increment enters the mainline through an auditable paper trail (Issue, Branch, PR, Peer Review).
- **Infrastructure as Code (IaC):** The operating system profile, build pipelines, and documentation are strictly version-controlled; manual, undocumented modifications inside chroot environments are prohibited.
- **Frictionless automation:** Quality and security controls are embedded directly within the repository to minimize administrative overhead for a two-maintainer team.

---

## 2. Toolchain Rationale & Decision Records

### 2.1 Version Control & Branching: GitHub Flow over Gitflow

- **Selected:** **GitHub Flow** (a single protected `main` branch with short-lived topic branches).
- **Why:** Enables fast feedback loops, minimizes merge conflicts, and aligns directly with automated continuous delivery.
- **Alternatives discarded:**
  - *Gitflow (`develop`, `release`, `feature`, `hotfix`):* Introduces unnecessary branching overhead and administrative friction for a two-engineer team.
  - *Unprotected mainline:* Discarded to guarantee baseline stability and enforce mandatory peer review.

### 2.2 Task Tracking: GitHub Projects (v2) over External Suites

- **Selected:** Native **GitHub Projects** using linked Kanban and roadmap views.
- **Why:** Zero-friction management. Issues, Pull Requests, and code revisions live in the exact same workspace. Native automations transition task states automatically upon PR creation, review, and merge events.
- **Alternatives discarded:**
  - *Jira / ClickUp:* Excessive configuration overhead and unnecessary context-switching outside the repository.
  - *Trello / Notion:* Lack bidirectional automation with Git branches, commit events, and native PR closures.

### 2.3 Dependency Auditing: Dependabot

- **Selected:** Native `.github/dependabot.yml` configured for weekly scans with Conventional Commits output.
- **Why:** Enforces supply chain security (*Shift-Left Security*). Dependabot inspects CI/CD actions and dependencies on a fixed weekly schedule without interrupting daily active development.
- **Alternatives discarded:**
  - *Manual audit reviews:* Highly prone to human omission during active implementation phases.
  - *Daily automated scanning bots:* Create excessive notification noise and distract from focused technical sprints.

### 2.4 Governance Baseline: Standardized Repository Metadata

- **Selected:** Minimalist root policies (`CONTRIBUTING.md`, `SECURITY.md`, `.gitignore`) alongside issue/PR templates.
- **Why:** Sets unambiguous standards for commit formatting, security disclosures, and architectural rationale before any code review takes place.
- **Contribution Standards:** All branch naming conventions, Conventional Commit semantics, pre-flight checks, and PR submission rules are strictly defined in [`CONTRIBUTING.md`](../CONTRIBUTING.md).

### 2.5 Branch Governance: Ruleset as Code

To eliminate human error and bypass mechanisms, branch protections are codified and enforced via GitHub Rulesets on `main`. The configuration is stored as Infrastructure as Code in [`.github/rulesets/main-protection.json`](../.github/rulesets/main-protection.json).

| Enforced Rule | Technical Configuration | Objective / Rationale |
| --- | --- | --- |
| **Restrict Direct Writes** | Block direct pushes and in-place branch edits | Mandates that every change originates from a dedicated feature branch. |
| **Pull Request Enforcement** | Require PR with minimum **1 approval** | Enforces the Four-Eyes principle; no code merges without peer validation. |
| **Review Invalidation** | Dismiss stale approvals on new commits | Invalidates existing approvals if additional commits modify the PR diff. |
| **Linear History** | Require squash merges | Guarantees a clean, single-commit log per feature aligned with Conventional Commits. |
| **Integrity Locks** | Block force pushes (`--force`) and branch deletion | Prevents destructive history rewrites and accidental branch removal. |
| **Status Checks** | Require passing checks *(configured alongside CI)* | Prevents merging code that fails automated linters, syntax checks, or builds. |

---

## 3. Development Environment & Workspace Isolation

For the complete network topology, Cisco 881 routing configurations, and Proxmox/VM network setups, refer to the [Network Infrastructure Documentation](network-infrastructure.md).

### 3.1 Isolated Workspaces vs Shared VM Accounts

- **Selected:** Dedicated, individual user accounts with scoped administrative privileges (`sudo` via `wheel` group) and separate local Git clones located in each maintainer's home directory (`~/IPLS`). Shared workspace configurations (`.vscode/settings.json` and `.vscode/extensions.json`) enforce consistent code formatting (such as Markdown auto-formatting on save via `markdownlint`) without requiring manual workstation synchronization.
- **Why:** Guarantees process isolation for remote editor instances (VS Code Remote-SSH), prevents scratchpad build collisions during local ISO profiling, avoids running development environments directly as root, and preserves non-repudiation of Git commit authorship.
- **Discarded practice:**
  - *A shared dev account or shared workspace folder:* Causes race conditions during package builds, file-lock collisions, and destroys commit author attribution.
  - *Direct root development:* Violates the principle of least privilege and increases the risk of host filesystem corruption during testing.

---

## 4. Kanban Governance & Workflow Automation

Task management is orchestrated through **GitHub Projects (v2)**. The board acts as the operational source of truth, automating task transitions to keep administrative overhead near zero.

```text
[ Backlog ] ──► [ Todo ] ──► [ In Progress ] ──► [ In Review ] ──► [ Done ]
 (Ideas/Debt)    (Scoped)      (Assigned)        (PR Open)       (Merged)
```

### 4.1 Column Definitions & Lifecycle States

1. **Backlog (Idea Reservoir & Technical Debt):**
   - **Purpose:** Centralizes raw feature ideas, tool suggestions, exploratory investigations, and non-blocking refactoring proposals.
   - **Rationale:** Prevents the active board from cluttering. Capturing an idea in the Backlog does not commit the team to immediate development; it serves as a triaged holding area.
   - **Entry Criteria:** Unassigned, unscoped, or unprioritized issues.

2. **Todo (Sprint Backlog & Ready Tasks):**
   - **Purpose:** Contains fully scoped, actionable tasks prioritized for the immediate development increment.
   - **Rationale:** Ensures that before code is written, the maintainers agree on requirements, architectural impact, and target component.
   - **Entry Criteria:** Issue created via the `Engineering Task` template, with an identified component (`Kernel & Hardening`, `Archiso & Userland`, `DevSecOps & CI/CD`, `Documentation & pls`, or `Lab & Infrastructure`) and an explicit Definition of Done.

3. **In Progress (Active Implementation):**
   - **Purpose:** Highlights work actively underway on a local development branch.
   - **Rationale:** Provides real-time visibility into who is working on what, preventing duplicated efforts on identical subsystems.
   - **Entry Criteria:** An engineer assigns themselves to the issue, pulls the latest `main`, creates a topic branch according to `CONTRIBUTING.md`, and transitions the card.

4. **In Review (Peer Audit & Four-Eyes Validation):**
   - **Purpose:** Holds completed work pending technical review, automated checks, and secondary maintainer approval.
   - **Rationale:** Enforces the Four-Eyes principle. No code enters `main` without peer scrutiny and verification.
   - **Entry Criteria:** Pull Request opened referencing the issue (`Closes #<issue_id>`), checklist filled out, and review requested.

5. **Done (Validated & Shipped):**
   - **Purpose:** Archives completed, tested, and integrated increments.
   - **Entry Criteria:** Pull Request approved, status checks green, squashed and merged into `main`, and remote topic branch deleted.

### 4.2 Native Board Automations

To maintain board accuracy without manual maintenance, the project applies native GitHub automations:

- **Automatic Intake (`Auto-add to project`):** Any newly opened issue in `TheMatako/IPLS` matching `is:issue` is automatically added to the board.
- **Initial Placement (`Item added to project`):** New items default to the **Todo** (or **Backlog**) column.
- **Review Synchronization (`Pull request opened`):** Opening a PR referencing an issue signals that review is pending.
- **Automated Closure (`Item closed` / `Pull request merged`):** When a Pull Request is merged, the associated issue closes automatically and its card shifts directly to **Done**.
