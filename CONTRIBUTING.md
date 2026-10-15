# Contributing to IPLS

Thank you for contributing to the **ISIMA Purple Linux System (IPLS)**!

IPLS is an engineering project developed by two ISIMA students, focused on security hardening, minimal attack surface, reproducible infrastructure, and custom Rust-based tooling.

To keep our codebase reliable, auditable, and production-ready, all contributors (including core team members) must strictly follow the guidelines detailed below.

---

## 1. Golden Rules

1. **English Only**: All documentation, source code, inline comments, commit messages, issues, and pull request discussions must be strictly in English.
2. **Documentation-as-Code**: Every technical modification, package addition, kernel parameter change, or security policy adjustment must be documented in the corresponding markdown file under `docs/`.
3. **Issue & Board Tracking**: Do not write code or open branches without an associated GitHub Issue. Every task must be tracked on our GitHub Projects board before development begins.
4. **No Direct Pushes**: Direct pushes to the `main` branch are forbidden. All code and documentation must enter via a dedicated branch and a Pull Request.
5. **Peer Review (Four-Eyes Principle)**: Every Pull Request requires at least one approving review from the other team member before merging.
6. **No Committed Secrets**: Never commit private SSH keys, lab passwords, API tokens, or internal network credentials.

---

## 2. Branching Strategy (GitHub Flow)

We follow a linear, branch-per-task model based on GitHub Flow:

- `main`: The single source of truth. It must remain stable, tested, and buildable at all times.
- **Working Branches**: Short-lived branches created from `main`, named with a descriptive prefix:
  - `feat/<short-description>`: New system feature or operational tooling (e.g., `feat/sysctl-hardening`).
  - `docs/<short-description>`: Documentation additions, corrections, or diagrams (e.g., `docs/state-of-the-art`).
  - `ci/<short-description>`: CI/CD workflows, runners, and automation recipes (e.g., `ci/github-actions-archiso`).
  - `fix/<short-description>`: Bug fixes, typos, or configuration adjustments (e.g., `fix/systemd-resolved-link`).
  - `refactor/<short-description>`: (optionnal) for refactoring purposes.

---

## 3. Commit Message Conventions

We enforce the **Conventional Commits** specification to maintain an auditable git history.

### Format

```text
<type>(<scope>): <description in imperative present tense>

[optional body: explain the context and motivation, not the implementation]

[optional footer: reference issues, e.g., Closes #42]
```

### Allowed Types

- `feat`: A new feature or system capability
- `fix`: A bug fix or syntax correction
- `docs`: Documentation changes only (`.md` files, diagrams)
- `style`: Formatting, whitespace, missing semicolons (no operational logic change)
- `refactor`: Refactoring code or configuration without altering behavior
- `test`: Adding or updating test suites, linter rules, or validation checks
- `ci`: Changes to CI/CD pipelines, build runners, or container environments
- `chore`: Maintenance tasks, repo configuration, metadata updates

### Examples

- `feat(kernel): switch base kernel configuration to linux-hardened`
- `docs(network): document Cisco 881 double NAT topology and static IPs`
- `ci(actions): add shellcheck linter workflow for build scripts`
- `fix(networkd): correct DNS symlink target in arch rootfs`

---

## 4. Development & Pull Request Lifecycle

> For details on our project milestones, roadmap, and delivery schedule, refer to [docs/project-management.md](docs/project-management.md).

Follow this step-by-step workflow for every technical increment:

1. **Pick or Create an Issue**: Ensure an open Issue exists. Assign it to yourself on the **GitHub Projects** board and set its status to `In Progress`.

2. **Branch Out**: Create your branch locally from an up-to-date `main`:

   ```bash
   git checkout main
   git pull origin main
   git checkout -b feat/your-feature-name
   ```

3. **Develop & Test Locally**: Implement your changes in atomic commits adhering to Conventional Commits. Run local pre-flight checks (linting, build tests) before pushing.
4. **Document**: Add or update corresponding `.md` records under `docs/` explaining the technical rationale.
5. **Push to Remote**:

   ```bash
   git push -u origin feat/your-feature-name
   ```

6. **Open a Pull Request**: Submit a PR targeting `main`. GitHub will automatically populate the description using our [Pull Request Template](.github/pull_request_template.md). Complete every section and link the issue (e.g., `Closes #12`).
7. **Peer Review**: Request a review from your teammate. Discuss, iterate, and apply requested adjustments.
8. **Squash and Merge**: Once approved and all CI checks pass, merge using **Squash and Merge** to guarantee a linear Git history, then delete the remote branch.

---

## 5. Security & Quality Baselines

- **Documentation & Markdown**: All `.md` files must follow clean formatting standards enforced by `markdownlint`. A workspace configuration (`.vscode/settings.json`) is provided to format and auto-fix rules on save.
- **Shell Scripts**: All scripts (`.sh`, PKGBUILDs, Archiso hooks) must pass `shellcheck` with zero warnings before merging. When targeting `/bin/sh`, avoid non-POSIX Bash extensions.
- **Rust Modules**: Custom tools must pass `cargo fmt --check`, `cargo clippy -- -D warnings`, and all unit tests defined under `cargo test`.
- **System Configurations**: Any hardening measure applied to `/etc` (sysctl parameters, firewall rules, service masking) must cite an established security standard (such as ANSSI BP-028 or CIS Benchmarks) in its related documentation.

### 5.1 Local Pre-Flight Checks (Makefile Automation)

To simplify compliance with our quality and security baselines, a root `Makefile` provides automated pre-flight checks. Run these targets locally before pushing branches or opening a Pull Request:

```bash
# Run all automated linters and quality checks (Shell + Docs + Rust)
make check

# Run shellcheck on all scripts and packaging recipes
make check-shell

# Run markdownlint on all documentation files
make check-docs

# Run formatting, clippy linter, and unit tests for Rust modules (using stable toolchain)
make check-rust
```

> **Note:** A failing check in `make check` will cause automated CI/CD pipelines to fail. Always ensure `make check` passes cleanly on your local development machine before submitting changes for peer review.
