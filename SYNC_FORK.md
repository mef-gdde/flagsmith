# Add upstream remote (once)
git remote add upstream https://github.com/Flagsmith/flagsmith.git

# Fetch latest upstream
git fetch upstream

# Rebase our commits on top of upstream main
git rebase upstream/main
