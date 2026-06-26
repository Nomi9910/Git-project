#!/bin/bash
# =============================================================
#  Day 5 - GitHub SSH Key Setup on RHEL 9
# =============================================================
#  By default, GitHub requires authentication for push/pull.
#  Two methods:
#   1. HTTPS + PAT (Personal Access Token)  — simpler to start
#   2. SSH keys                              — more secure, no password
#
#  SSH key authentication:
#   - You generate a key PAIR on your Linux machine
#   - Private key stays on your machine (NEVER share!)
#   - Public key is uploaded to GitHub
#   - GitHub verifies you hold the matching private key
# =============================================================

# ── Step 1: Check for Existing SSH Keys ───────────────────────
ls -la ~/.ssh/
# Look for: id_ed25519, id_rsa, id_ecdsa (and their .pub counterparts)
# If these exist, you may already have keys — skip to Step 3

# ── Step 2: Generate a New SSH Key Pair ──────────────────────
# Ed25519 is modern, fast, and secure (RECOMMENDED)
ssh-keygen -t ed25519 -C "your-email@example.com"

# RSA 4096 (if ed25519 is not supported on old systems)
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# During key generation:
# Enter file: press Enter (use default ~/.ssh/id_ed25519)
# Passphrase: enter a strong passphrase (adds extra security layer)
# Confirm passphrase: re-enter it

# What gets created:
# ~/.ssh/id_ed25519      ← PRIVATE key (protect this!)
# ~/.ssh/id_ed25519.pub  ← PUBLIC key (share this with GitHub)

# View the generated keys
ls -la ~/.ssh/
cat ~/.ssh/id_ed25519.pub              # This is what you add to GitHub

# ── Step 3: Start the SSH Agent ───────────────────────────────
# The agent caches your key so you don't enter passphrase repeatedly
eval "$(ssh-agent -s)"
# Output: Agent pid 12345

# Add your private key to the agent
ssh-add ~/.ssh/id_ed25519

# Verify key is loaded
ssh-add -l

# Make SSH agent persist across sessions (add to ~/.bashrc or ~/.bash_profile)
cat >> ~/.bashrc << 'AGENT'

# Start SSH agent automatically
if [ -z "$SSH_AUTH_SOCK" ]; then
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
AGENT

# ── Step 4: Add Public Key to GitHub ─────────────────────────
# Copy your public key to clipboard/display it
cat ~/.ssh/id_ed25519.pub
# COPY the entire output — it starts with: ssh-ed25519 AAAA...

# Then on GitHub:
# 1. Log in to github.com
# 2. Click your profile picture → Settings
# 3. Left sidebar → "SSH and GPG keys"
# 4. Click "New SSH key"
# 5. Title: "RHEL9-server" (something descriptive)
# 6. Key type: Authentication Key
# 7. Paste your public key
# 8. Click "Add SSH key"

# ── Step 5: Test SSH Connection to GitHub ────────────────────
ssh -T git@github.com
# First time: "Are you sure you want to continue connecting? (yes/no)"
# Type: yes
# Success: "Hi Nomi9910! You've successfully authenticated..."

# Verbose test (for troubleshooting)
ssh -vT git@github.com

# ── Step 6: Configure SSH for GitHub (optional but useful) ───
cat >> ~/.ssh/config << 'SSHCONFIG'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
SSHCONFIG
chmod 600 ~/.ssh/config

# ── Step 7: Set Correct Permissions ──────────────────────────
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config

# ── Step 8: Use SSH URL for Repos ────────────────────────────
# Instead of HTTPS: https://github.com/user/repo.git
# Use SSH:          git@github.com:user/repo.git

# Clone using SSH
git clone git@github.com:Nomi9910/my-project.git

# Change existing repo from HTTPS to SSH
git remote -v                                          # Check current
git remote set-url origin git@github.com:Nomi9910/my-project.git
git remote -v                                          # Verify change

# ── Step 9: Multiple GitHub Accounts (Advanced) ───────────────
# ~/.ssh/config for multiple accounts:
cat >> ~/.ssh/config << 'MULTI'
# Personal GitHub
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal

# Work GitHub
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
MULTI

# Then clone using the host alias:
git clone git@github-personal:Nomi9910/repo.git
git clone git@github-work:company/repo.git
