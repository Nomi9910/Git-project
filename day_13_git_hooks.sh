#!/bin/bash
# =============================================================
#  Day 13 - Git Hooks
# =============================================================
#  Git Hooks are scripts that run automatically before or after
#  specific Git events (commit, push, merge, etc.)
#  They live in: .git/hooks/  (local, not committed to repo)
#
#  Client-side hooks (run locally):
#   pre-commit       — before commit is created
#   commit-msg       — validate commit message format
#   post-commit      — after commit
#   pre-push         — before git push
#
#  Server-side hooks (run on remote):
#   pre-receive      — before accepting a push
#   post-receive     — after accepting a push (trigger deploy)
#
#  Hooks must be executable: chmod +x .git/hooks/hookname
# =============================================================

cd ~/my-project

# View available hook templates
ls .git/hooks/
# applypatch-msg.sample  pre-applypatch.sample  pre-commit.sample
# pre-push.sample        pre-rebase.sample      commit-msg.sample

# ── Hook 1: pre-commit — Block Bad Code ───────────────────────
cat > .git/hooks/pre-commit << 'HOOK'
#!/bin/bash
# ─────────────────────────────────────────────────────
# Pre-commit hook: enforce code quality before commit
# ─────────────────────────────────────────────────────

echo "Running pre-commit checks..."

# Check 1: No debug print statements in Python files
if git diff --cached --name-only | grep -q "\.py$"; then
    if git diff --cached | grep -E "^\+.*print\(|^\+.*pdb\.set_trace|^\+.*breakpoint\(\)" > /dev/null; then
        echo "❌ ERROR: Debug statements found (print/pdb/breakpoint). Remove them first."
        exit 1
    fi
fi

# Check 2: No TODO/FIXME in staged files
if git diff --cached | grep -E "^\+.*(TODO|FIXME|HACK|XXX)" > /dev/null; then
    echo "⚠️  WARNING: TODO/FIXME found in staged changes. Continue? (y/n)"
    exec < /dev/tty
    read answer
    if [ "$answer" != "y" ]; then
        exit 1
    fi
fi

# Check 3: No secrets/credentials in staged files
if git diff --cached | grep -iE "^\+.*(password\s*=|api_key\s*=|secret\s*=|token\s*=)" > /dev/null; then
    echo "❌ ERROR: Possible secret/credential detected in staged changes!"
    echo "   Remove sensitive data before committing."
    exit 1
fi

# Check 4: Run Python linting if .py files staged
if git diff --cached --name-only | grep -q "\.py$"; then
    if command -v flake8 &>/dev/null; then
        git diff --cached --name-only | grep "\.py$" | xargs flake8 --max-line-length=120
        if [ $? -ne 0 ]; then
            echo "❌ ERROR: Flake8 linting failed. Fix errors before committing."
            exit 1
        fi
    fi
fi

echo "✅ All pre-commit checks passed!"
exit 0
HOOK
chmod +x .git/hooks/pre-commit

# ── Hook 2: commit-msg — Enforce Commit Format ───────────────
cat > .git/hooks/commit-msg << 'HOOK'
#!/bin/bash
# ─────────────────────────────────────────────────────
# commit-msg hook: enforce Conventional Commits format
# Format: type(scope): description
# Types: feat, fix, docs, style, refactor, test, chore, ci
# Example: feat(auth): add JWT token validation
# ─────────────────────────────────────────────────────

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Pattern: type(optional-scope): description
PATTERN="^(feat|fix|docs|style|refactor|test|chore|ci|perf|build|revert)(\(.+\))?: .{1,72}$"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "❌ INVALID commit message format!"
    echo ""
    echo "   Your message: $COMMIT_MSG"
    echo ""
    echo "   Required format: type(scope): description"
    echo "   Valid types: feat, fix, docs, style, refactor, test, chore, ci"
    echo ""
    echo "   Examples:"
    echo "     feat(auth): add login page"
    echo "     fix(api): resolve null pointer on user endpoint"
    echo "     docs: update README installation steps"
    echo "     chore: upgrade dependencies"
    exit 1
fi

echo "✅ Commit message format is valid."
exit 0
HOOK
chmod +x .git/hooks/commit-msg

# ── Hook 3: pre-push — Run Tests Before Pushing ──────────────
cat > .git/hooks/pre-push << 'HOOK'
#!/bin/bash
# ─────────────────────────────────────────────────────
# pre-push hook: run tests before allowing git push
# ─────────────────────────────────────────────────────

REMOTE="$1"
URL="$2"

echo "Running tests before push to $REMOTE ($URL)..."

# Run pytest if it's available
if command -v pytest &>/dev/null; then
    pytest tests/ -q --tb=short
    if [ $? -ne 0 ]; then
        echo "❌ Tests FAILED! Push aborted."
        echo "   Fix failing tests before pushing."
        exit 1
    fi
    echo "✅ All tests passed!"
fi

# Prevent direct push to main/master
while read local_ref local_sha remote_ref remote_sha; do
    if [[ "$remote_ref" == "refs/heads/main" || "$remote_ref" == "refs/heads/master" ]]; then
        echo "❌ Direct push to main/master is BLOCKED!"
        echo "   Please use a feature branch and open a Pull Request."
        exit 1
    fi
done

exit 0
HOOK
chmod +x .git/hooks/pre-push

# ── Sharing Hooks with the Team ───────────────────────────────
# .git/hooks is NOT committed — each dev must set up their own
# Solution: store hooks in the repo and symlink or configure

mkdir -p .githooks

# Copy hooks to tracked directory
cp .git/hooks/pre-commit  .githooks/
cp .git/hooks/commit-msg  .githooks/
cp .git/hooks/pre-push    .githooks/

git add .githooks/
git commit -m "chore: add shared git hooks"

# Tell Git to use .githooks/ directory (Git 2.9+)
git config core.hooksPath .githooks

# Add to onboarding docs — every dev runs:
# git config core.hooksPath .githooks

# ── Bypassing Hooks (emergency use only!) ─────────────────────
git commit --no-verify -m "emergency: bypass hooks"
git push --no-verify
