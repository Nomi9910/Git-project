#!/bin/bash
# =============================================================
#  Day 3 - Staging, Committing & Viewing History
# =============================================================
#  The Git workflow has 3 key areas:
#   1. Working Directory — your actual files (modified/untracked)
#   2. Staging Area (Index) — files you've "git add"-ed (ready)
#   3. Repository — committed snapshots stored in .git/
#
#  Workflow: Edit files → git add → git commit → git push
# =============================================================

cd ~/my-project

# ── Step 1: Create/Modify Files ───────────────────────────────
echo "# My Project" > README.md
echo "print('Hello Git!')" > app.py
mkdir src
echo "# Source code" > src/main.py

# ── Step 2: Check What Git Sees ──────────────────────────────
git status
# Shows: Untracked files: README.md, app.py, src/

# ── Step 3: Stage Files (git add) ────────────────────────────
git add README.md                    # Stage a single file
git add app.py src/main.py           # Stage multiple files
git add src/                         # Stage entire directory
git add .                            # Stage ALL changes in current dir
git add -A                           # Stage ALL changes (add + delete + modify)
git add -u                           # Stage only tracked files (no new files)
git add -p                           # Interactive — stage chunks/hunks

# Check staging area
git status
git diff --staged                    # Show what's staged vs last commit
git diff                             # Show unstaged changes

# Unstage a file (keep the change, just remove from stage)
git restore --staged README.md       # Modern way (Git 2.23+)
git reset HEAD README.md             # Old way (still works)

# ── Step 4: Commit (git commit) ───────────────────────────────
git commit -m "Initial commit: add README and app.py"

# Commit with multi-line message (opens editor)
git commit

# Stage all tracked files AND commit in one step
git commit -am "Update app.py with new feature"
# NOTE: -a does NOT add untracked (new) files

# Amend last commit (fix message or add forgotten file)
git commit --amend -m "Corrected commit message"
git add forgotten.py
git commit --amend --no-edit          # Add file to last commit, keep message

# ── Step 5: View History (git log) ────────────────────────────
git log                               # Full commit history
git log --oneline                     # Compact one-line format
git log --oneline --graph             # ASCII branch graph
git log --oneline --graph --all       # Include all branches
git log --oneline --decorate          # Show branch/tag labels
git log -5                            # Last 5 commits only
git log --since="2 weeks ago"         # Commits in last 2 weeks
git log --since="2025-01-01"          # Since specific date
git log --author="Alice"              # Commits by specific author
git log --grep="bugfix"               # Commits with 'bugfix' in message
git log -- README.md                  # Commits that touched README.md
git log -p                            # Show diff for each commit
git log --stat                        # Show file change stats

# Pretty custom format
git log --format="%h %an %ar %s"      # hash, author, age, subject
git log --format="%C(yellow)%h%Creset %s %C(green)(%cr)%Creset"

# ── Step 6: Inspect Specific Commits ─────────────────────────
git show                              # Show last commit + diff
git show abc1234                      # Show specific commit by hash
git show HEAD                         # Show the latest commit
git show HEAD~1                       # Show 1 commit before HEAD
git show HEAD~3                       # Show 3 commits before HEAD

# ── Step 7: Useful Shortcuts ─────────────────────────────────
git diff HEAD                         # All changes since last commit
git blame README.md                   # Who changed each line and when
git shortlog -sn                      # Commit count per author
git log --oneline | wc -l             # Total number of commits

# ── The .gitignore File ───────────────────────────────────────
# Tell Git to ignore certain files/patterns
cat > .gitignore << 'GITIGNORE'
# Python
__pycache__/
*.pyc
*.pyo
.env
venv/

# Logs & temp files
*.log
*.tmp
*.swp

# OS files
.DS_Store
Thumbs.db

# Secrets — NEVER commit these!
*.key
*.pem
secrets.txt
.env.local
GITIGNORE

git add .gitignore
git commit -m "Add .gitignore"
