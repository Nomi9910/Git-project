#!/bin/bash
# =============================================================
#  Day 15 - Git Best Practices & Team Workflows
# =============================================================
#  After learning the mechanics of Git, the most important skill
#  is knowing HOW to use it effectively in a team.
#  This lesson covers: commit conventions, branching strategies,
#  .gitignore patterns, alias setup, and professional workflows.
# =============================================================

# ── Conventional Commits Standard ────────────────────────────
# Format: type(scope): description
# Types:
#   feat     — new feature
#   fix      — bug fix
#   docs     — documentation only
#   style    — formatting, no code logic change
#   refactor — code restructure, no new feature or fix
#   test     — adding or fixing tests
#   chore    — build process, dependencies, tooling
#   ci       — CI/CD configuration
#   perf     — performance improvement
#   revert   — revert a previous commit

# Good commit messages:
git commit -m "feat(auth): add JWT token refresh endpoint"
git commit -m "fix(db): resolve connection timeout on idle queries"
git commit -m "docs: update API authentication section in README"
git commit -m "chore: upgrade ansible to 9.1.0"
git commit -m "ci: add RHEL 9 to test matrix"
git commit -m "refactor(user): extract validation logic to separate module"

# Bad commit messages (AVOID):
# git commit -m "fix"
# git commit -m "stuff"
# git commit -m "asdfgh"
# git commit -m "WIP"
# git commit -m "changes"

# ── Branching Strategies ──────────────────────────────────────

# 1. GitHub Flow (simple — best for most teams)
#    main → feature branches → PR → merge to main → deploy
#
#    Rules:
#    - main is always deployable
#    - Work on named feature branches
#    - Open PRs early for discussion
#    - Merge only after review + CI passes

# 2. Git Flow (complex — for scheduled releases)
#    main + develop + feature/* + release/* + hotfix/*
#
# 3. Trunk-Based Development (advanced — for CI/CD)
#    Everyone commits to main (or short-lived branches < 1 day)

# ── Branch Naming Conventions ─────────────────────────────────
# feature/short-description
# fix/issue-number-description
# hotfix/critical-bug-name
# release/v1.2.0
# chore/update-dependencies
# docs/update-readme

git switch -c feature/add-user-auth
git switch -c fix/42-login-redirect-broken
git switch -c hotfix/sql-injection-vulnerability
git switch -c release/v2.0.0

# ── The Perfect .gitignore for RHEL 9 Projects ────────────────
cat > ~/.gitignore_global << 'GITIGNORE'
# ── OS Files ──────────────────────────────────────────────────
.DS_Store
Thumbs.db
desktop.ini
*~
.nfs*

# ── Editor Files ──────────────────────────────────────────────
.vscode/
.idea/
*.swp
*.swo
*.vim
.vim/

# ── Logs & Temp ───────────────────────────────────────────────
*.log
*.tmp
*.temp
*.bak
*.orig

# ── Secrets — NEVER COMMIT THESE ─────────────────────────────
.env
.env.*
!.env.example
*.key
*.pem
*.p12
*.pfx
secrets.yml
secrets.json
vault_pass.txt
.vault_pass

# ── Python ────────────────────────────────────────────────────
__pycache__/
*.pyc
*.pyo
.venv/
venv/
env/
*.egg-info/
dist/
build/

# ── Node.js ───────────────────────────────────────────────────
node_modules/
npm-debug.log*
yarn-error.log

# ── Ansible ───────────────────────────────────────────────────
*.retry
GITIGNORE

# Set global gitignore
git config --global core.excludesFile ~/.gitignore_global

# ── Essential Git Aliases ─────────────────────────────────────
git config --global alias.st    "status -sb"
git config --global alias.co    "checkout"
git config --global alias.sw    "switch"
git config --global alias.br    "branch -vv"
git config --global alias.bra   "branch -a"
git config --global alias.lg    "log --oneline --graph --decorate --all"
git config --global alias.lgs   "log --oneline --graph --decorate -20"
git config --global alias.last  "log -1 HEAD --stat"
git config --global alias.df    "diff"
git config --global alias.dfs   "diff --staged"
git config --global alias.undo  "reset --soft HEAD~1"
git config --global alias.unstage "restore --staged"
git config --global alias.aliases "config --get-regexp alias"
git config --global alias.whoami "config user.email"
git config --global alias.contributors "shortlog -sn --all"

# ── Daily Git Workflow Cheatsheet ─────────────────────────────
# START OF DAY:
# git fetch origin                    # Get latest remote info
# git pull --rebase origin main       # Update local main

# FEATURE WORK:
# git switch -c feature/my-task       # Create branch
# [... make changes ...]
# git add -p                          # Stage selectively
# git commit -m "feat: my change"     # Commit with good message
# git push -u origin feature/my-task  # Push branch

# KEEP BRANCH UPDATED:
# git fetch origin
# git rebase origin/main              # Replay commits on latest main

# BEFORE PR:
# git rebase -i HEAD~N                # Clean up commits (squash WIPs)
# git push --force-with-lease         # Force push after rebase

# CODE REVIEW:
# gh pr create                        # Open PR
# gh pr checkout 42                   # Review someone else's PR
# gh pr review 42 --approve           # Approve

# AFTER MERGE:
# git switch main
# git pull origin main
# git branch -d feature/my-task
# git remote prune origin

# ── Git Security Checklist ────────────────────────────────────
# ✅ Never commit .env, passwords, API keys, private keys
# ✅ Use .gitignore BEFORE first commit
# ✅ Use pre-commit hooks to catch secrets
# ✅ Enable branch protection on main
# ✅ Use SSH keys (not HTTPS passwords)
# ✅ Sign commits with GPG (optional but professional)
# ✅ Review your diff before committing: git diff --staged
# ✅ Use git log --all before force push
# ✅ Revoke and rotate any token/key accidentally committed

# ── GPG Commit Signing (Professional Level) ───────────────────
# Generate GPG key
gpg --full-generate-key

# List keys
gpg --list-secret-keys --keyid-format=long

# Export public key to add to GitHub
gpg --armor --export YOUR_KEY_ID

# Configure Git to sign commits
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
git config --global gpg.program gpg

# Now all commits are signed:
git commit -m "feat: signed commit"
git log --show-signature -1              # Verify signature
