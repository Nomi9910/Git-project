#!/bin/bash
# =============================================================
#  Day 12 - GitHub Actions & CI/CD Basics
# =============================================================
#  GitHub Actions is a CI/CD platform built into GitHub.
#  It automates: testing, building, linting, and deploying code
#  whenever events happen (push, pull_request, schedule, etc.)
#
#  Key concepts:
#   Workflow  — a YAML file in .github/workflows/
#   Event     — what triggers the workflow (push, PR, cron)
#   Job       — a set of steps running on a virtual machine
#   Step      — individual command or action
#   Action    — reusable pre-built step from marketplace
#   Runner    — the server that executes jobs (GitHub-hosted or self-hosted)
# =============================================================

# ── Step 1: Create Workflow Directory ────────────────────────
mkdir -p .github/workflows

# ── Workflow 1: Basic CI — Test on Every Push ─────────────────
cat > .github/workflows/ci.yml << 'YAML'
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    name: Run Tests
    runs-on: ubuntu-latest          # GitHub-hosted runner

    steps:
      - name: Checkout code
        uses: actions/checkout@v4   # Clone the repo

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run linter
        run: |
          pip install flake8
          flake8 . --count --select=E9,F63,F7,F82

      - name: Run tests
        run: |
          pip install pytest
          pytest tests/ -v

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: test-results/
YAML

# ── Workflow 2: Multi-Job with Matrix Testing ──────────────────
cat > .github/workflows/matrix.yml << 'YAML'
name: Matrix Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.10', '3.11', '3.12']
      fail-fast: false              # Don't cancel all if one fails

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Run tests
        run: pytest tests/ -v
YAML

# ── Workflow 3: Deploy to Server on Push to Main ──────────────
cat > .github/workflows/deploy.yml << 'YAML'
name: Deploy to Production

on:
  push:
    branches: [ main ]
  release:
    types: [ published ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production          # Requires approval

    steps:
      - uses: actions/checkout@v4

      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /opt/myapp
            git pull origin main
            pip install -r requirements.txt
            systemctl restart myapp
            systemctl status myapp
YAML

# ── Workflow 4: Scheduled Job (Cron) ──────────────────────────
cat > .github/workflows/nightly.yml << 'YAML'
name: Nightly Security Scan

on:
  schedule:
    - cron: '0 2 * * *'            # Every day at 2 AM UTC
  workflow_dispatch:                 # Allow manual trigger

jobs:
  security-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run security audit
        run: |
          pip install safety
          safety check -r requirements.txt

      - name: Notify on failure
        if: failure()
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: 'Security scan failed',
              body: 'Nightly security scan detected vulnerabilities!'
            })
YAML

# ── Adding Secrets to GitHub ──────────────────────────────────
# 1. Go to repo → Settings → Secrets and variables → Actions
# 2. Click "New repository secret"
# 3. Name: SERVER_HOST  Value: 192.168.1.100
# 4. Name: SSH_PRIVATE_KEY  Value: (paste private key content)

# Via GitHub CLI:
gh secret set SERVER_HOST --body "192.168.1.100"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_ed25519
gh secret list                              # View all secret names

# ── Commit Workflows ──────────────────────────────────────────
git add .github/
git commit -m "ci: add GitHub Actions workflows"
git push origin main
# Watch workflows run at: github.com/user/repo/actions
