#!/bin/bash
# =============================================================
#  Day 7 - Pull Requests & Code Review on GitHub
# =============================================================
#  A Pull Request (PR) is a GitHub feature that lets you:
#   - Propose changes from one branch to another
#   - Request code review from teammates
#   - Discuss changes, add comments, request modifications
#   - Run automated tests (CI/CD) before merging
#
#  PR Workflow:
#   1. Create feature branch locally
#   2. Commit your changes
#   3. Push branch to GitHub
#   4. Open a Pull Request on GitHub
#   5. Get review and approval
#   6. Merge the PR
#   7. Delete the branch
# =============================================================

# ── Step 1: Create & Work on a Feature Branch ────────────────
git switch main
git pull --rebase origin main              # Start from latest main

git switch -c feature/add-login-page
# Make your changes...
echo "<html><body>Login Page</body></html>" > login.html
git add login.html
git commit -m "feat: add login page HTML"

echo "body { font-family: Arial; }" > style.css
git add style.css
git commit -m "style: add base CSS for login page"

# ── Step 2: Push Branch to GitHub ────────────────────────────
git push -u origin feature/add-login-page
# Output includes a GitHub URL to open PR directly!
# "Create a pull request for 'feature/add-login-page' on GitHub"

# ── Step 3: Open Pull Request on GitHub ──────────────────────
# 1. Go to your repo on github.com
# 2. Click the "Compare & pull request" button (yellow banner)
#    OR: Pull requests tab → New pull request
# 3. Fill in:
#    - Title: "feat: Add login page"
#    - Description: What did you change? Why? Any notes?
#    - Reviewers: @teammate
#    - Labels: feature, bug, documentation
#    - Milestone: v1.0
#    - Assignees: yourself
# 4. Click "Create pull request"

# ── Good PR Description Template ─────────────────────────────
# ## What this PR does
# Adds a login page with basic HTML and CSS.
#
# ## Why
# Required for user authentication feature (closes #42).
#
# ## How to test
# 1. Open login.html in browser
# 2. Verify form renders correctly
#
# ## Screenshots
# [paste screenshot here]
#
# ## Checklist
# - [x] Code follows style guide
# - [x] Tests added/updated
# - [x] Documentation updated

# ── Step 4: Responding to Review Feedback ────────────────────
# Reviewer left a comment on login.html? Make changes locally:
vim login.html                             # Apply feedback
git add login.html
git commit -m "fix: address code review feedback on login form"
git push origin feature/add-login-page    # Push updates to same PR (auto-updates!)

# ── Step 5: Merge Strategies on GitHub ───────────────────────
# GitHub offers 3 merge options:
#
# 1. "Merge commit"      — Keeps all commits + adds a merge commit
#                          Best for: feature branches with meaningful history
#
# 2. "Squash and merge"  — Combines all PR commits into ONE commit
#                          Best for: small features, clean main history
#
# 3. "Rebase and merge"  — Replays commits on top of main (no merge commit)
#                          Best for: linear history preference

# ── Step 6: After Merging — Clean Up ─────────────────────────
# GitHub offers "Delete branch" button after merge — click it!
# Then locally:
git switch main
git pull origin main                       # Get the merged changes
git branch -d feature/add-login-page      # Delete local branch
git remote prune origin                    # Clean up deleted remote branch refs

# ── Step 7: Review Someone Else's PR ─────────────────────────
# Check out their branch locally to test:
git fetch origin
git switch -c review/feature-login origin/feature/add-login-page
# Test their changes, then:
git switch main
git branch -D review/feature-login        # Clean up

# ── Using GitHub CLI (gh) for PRs ────────────────────────────
# Install GitHub CLI
sudo dnf install -y gh

# Authenticate
gh auth login

# Create PR from command line
gh pr create --title "feat: Add login page" \
             --body "Adds login HTML and CSS" \
             --base main \
             --head feature/add-login-page

gh pr list                                 # List open PRs
gh pr view 42                              # View PR #42
gh pr checkout 42                          # Checkout PR #42 locally
gh pr review 42 --approve                  # Approve PR
gh pr merge 42 --squash                    # Merge PR with squash
gh pr close 42                             # Close PR without merging
