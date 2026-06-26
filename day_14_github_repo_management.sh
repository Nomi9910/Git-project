#!/bin/bash
# =============================================================
#  Day 14 - GitHub Repository Management
# =============================================================
#  Beyond just storing code, GitHub provides a full suite of
#  project management tools: Issues, Projects, Wikis, Branch
#  Protection Rules, Collaborators, and repository settings.
#
#  This lesson covers the essential repo management tasks
#  every developer and sysadmin should know on GitHub.
# =============================================================

# ── GitHub CLI Setup ──────────────────────────────────────────
# Install GitHub CLI on RHEL 9
sudo dnf install -y gh

# Authenticate
gh auth login
# Follow prompts: GitHub.com → SSH → authenticate via browser

gh auth status                          # Check auth status
gh auth refresh                         # Refresh token

# ── Repository Operations ─────────────────────────────────────
# Create repositories
gh repo create my-project --private --clone
gh repo create my-project --public --description "My awesome project"
gh repo create org/my-project --private  # Under an organization

# List repositories
gh repo list                             # Your repos
gh repo list Nomi9910                    # Specific user
gh repo list --limit 50                  # More results

# View repo info
gh repo view                             # Current repo
gh repo view Nomi9910/Linux-project      # Specific repo
gh repo view --web                       # Open in browser

# Clone repos
gh repo clone Nomi9910/Linux-project
gh repo clone Nomi9910/Linux-project ~/projects/linux  # Custom path

# Fork a repo
gh repo fork upstream/project --clone
gh repo fork upstream/project --org myorg  # Fork into org

# Archive / delete
gh repo archive Nomi9910/old-project
gh repo delete Nomi9910/test-project --yes

# ── Branch Protection Rules ───────────────────────────────────
# Set up via GitHub UI: Settings → Branches → Add rule
# OR via GitHub CLI:
gh api repos/Nomi9910/my-project/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/test"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null

# Common protection settings:
# ✅ Require pull request before merging
# ✅ Require approvals (1-2 reviewers)
# ✅ Require status checks to pass (CI must pass)
# ✅ Require branches to be up to date before merging
# ✅ Include administrators
# ✅ Restrict who can push to matching branches

# ── Collaborators & Teams ─────────────────────────────────────
# Add a collaborator (personal repo)
gh api repos/Nomi9910/my-project/collaborators/alice \
  --method PUT \
  --field permission=push     # read, triage, write, maintain, admin

# List collaborators
gh api repos/Nomi9910/my-project/collaborators

# ── Issues Management ─────────────────────────────────────────
# Create issues
gh issue create --title "Bug: login page crashes" \
                --body "Steps to reproduce..." \
                --label bug \
                --assignee Nomi9910

gh issue create --title "Feature: add dark mode" \
                --label enhancement

# List issues
gh issue list                            # Open issues
gh issue list --state closed             # Closed issues
gh issue list --label bug                # Filter by label
gh issue list --assignee Nomi9910        # Assigned to me

# View and manage
gh issue view 42
gh issue close 42
gh issue reopen 42
gh issue comment 42 --body "Working on this now"

# ── Labels ────────────────────────────────────────────────────
gh label list
gh label create "high-priority" --color "FF0000" --description "Urgent fix needed"
gh label delete "wontfix"
gh label edit "bug" --color "d73a4a"

# ── GitHub Projects (Kanban/Roadmap) ─────────────────────────
# Create a project board
gh project create --owner Nomi9910 --title "Sprint 1"

# List projects
gh project list --owner Nomi9910

# ── Repository Settings via CLI ───────────────────────────────
# Update repo description and settings
gh repo edit --description "Updated description"
gh repo edit --homepage "https://myapp.com"
gh repo edit --visibility private
gh repo edit --enable-issues
gh repo edit --enable-wiki
gh repo edit --enable-projects
gh repo edit --default-branch main

# ── .github Special Directory ─────────────────────────────────
mkdir -p .github

# Issue template
mkdir -p .github/ISSUE_TEMPLATE
cat > .github/ISSUE_TEMPLATE/bug_report.md << 'MD'
---
name: Bug Report
about: Report a bug
labels: bug
---

## Bug Description
A clear description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click '...'
3. See error

## Expected Behavior
What should happen.

## Actual Behavior
What actually happens.

## Environment
- OS: RHEL 9
- Version: v1.0.0
MD

# PR template
cat > .github/pull_request_template.md << 'MD'
## Summary
Brief description of changes.

## Changes Made
- [ ] Change 1
- [ ] Change 2

## Testing
Describe how you tested this.

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No secrets committed
MD

git add .github/
git commit -m "chore: add GitHub issue and PR templates"
git push origin main
