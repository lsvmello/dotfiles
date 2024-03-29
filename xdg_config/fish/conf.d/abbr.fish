abbr -a e 'nvim'
abbr -a c 'clear'

abbr -a l 'ls'
abbr -a ll 'ls -l'
abbr -a lll 'ls -la'

# Git abbreviations
abbr -a g 'git'
# Add (a)
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gad 'git diff --no-ext-diff --cached'
abbr -a gaD 'git diff --no-ext-diff --cached --word-diff'
abbr -a gap 'git add --patch'
abbr -a gau 'git add --update'
# Branch (b)
abbr -a gb 'git branch'
abbr -a gba 'git branch --all --verbose'
abbr -a gbc 'git checkout -b'
abbr -a gbd 'git branch --delete'
abbr -a gbD 'git branch --delete --force'
abbr -a gbl 'git branch --verbose'
abbr -a gbL 'git branch --all --verbose'
abbr -a gbm 'git branch --move'
abbr -a gbM 'git branch --move --force'
abbr -a gbr 'git branch --move'
abbr -a gbR 'git branch --move --force'
abbr -a gbs 'git show-branch'
abbr -a gbS 'git show-branch --all'
abbr -a gbv 'git branch --verbose'
abbr -a gbV 'git branch --verbose --verbose'
abbr -a gbx 'git branch --delete'
abbr -a gbX 'git branch --delete --force'
# Checkout (co)
abbr -a gco 'git checkout'
abbr -a gcob 'git checkout -b'
# Cherry-pick (cp)
abbr -a gcp 'git cherry-pick --ff'
abbr -a gcps 'git cherry --verbose --abbrev'
abbr -a gcpS 'git cherry --verbose'
# Clean (C)
abbr -a gC 'git clean --dry-run'
abbr -a gCf 'git clean --force'
# Clone (cl)
abbr -a gcl 'git clone'
abbr -a gclr 'git clone --recurse-submodules'
# Commit (c)
abbr -a gc 'git commit --verbose'
abbr -a gcO 'git checkout --patch'
abbr -a gcP 'git cherry-pick --no-commit'
abbr -a gcR 'git reset "HEAD^"'
abbr -a gca 'git commit --verbose --all'
abbr -a gcam 'git commit --all --message'
abbr -a gcf 'git commit --amend --no-edit'
abbr -a gcF 'git commit --verbose --amend'
abbr -a gcm 'git commit --message'
abbr -a gcmS 'git commit --message --signoff'
abbr -a gcs 'git show'
abbr -a gcS 'git commit --verbose --signoff'
abbr -a gcss 'git show --pretty=short --show-signature'
# Diff (d)
abbr -a gd 'git diff --no-ext-diff'
abbr -a gD 'git diff --no-ext-diff --word-diff'
# Fetch (f)
abbr -a gf 'git fetch'
abbr -a gfa 'git fetch --all --prune'
# Grep (g)
abbr -a gg 'git grep'
abbr -a ggi 'git grep --ignore-case'
abbr -a ggl 'git grep --files-with-matches'
abbr -a ggL 'git grep --files-without-matches'
abbr -a ggv 'git grep --invert-match'
abbr -a ggw 'git grep --word-regexp'
# Log (l)
abbr -a gl 'git log --topo-order'
abbr -a glc 'git shortlog --summary --numbered'
abbr -a gld 'git log --topo-order --stat --patch --full-diff'
abbr -a glg 'git log --topo-order --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Creset(%cr) %C(bold blue)<%an>%Creset"'
abbr -a gls 'git log --topo-order --stat'
abbr -a glS 'git log --show-signature'
# Merge (m)
abbr -a gm 'git merge'
abbr -a gma 'git merge --abort'
abbr -a gmC 'git merge --no-commit'
abbr -a gmF 'git merge --no-ff'
abbr -a gmt 'git mergetool'
# Pull (P)
abbr -a gP 'git pull'
abbr -a gPa 'git pull --autostash'
abbr -a gPr 'git pull --rebase'
abbr -a gPra 'git pull --rebase --autostash'
# Push (p)
abbr -a gp 'git push'
abbr -a gpa 'git push --all'
abbr -a gpA 'git push --all && git push --tags'
abbr -a gpf 'git push --force-with-lease'
abbr -a gpF 'git push --force'
abbr -a gpt 'git push --tags'
abbr -a gpu 'git push --set-upstream origin'
# Rebase (rb)
abbr -a grb 'git rebase'
abbr -a grba 'git rebase --abort'
abbr -a grbc 'git rebase --continue'
abbr -a grbi 'git rebase --interactive'
abbr -a grbs 'git rebase --skip'
# Remote (rm)
abbr -a grm 'git remote'
abbr -a grma 'git remote add'
abbr -a grml 'git remote --verbose'
abbr -a grmm 'git remote rename'
abbr -a grmp 'git remote prune'
abbr -a grms 'git remote show'
abbr -a grmu 'git remote update'
abbr -a grmx 'git remote rm'
# Remove (x)
abbr -a gx 'git rm -r'
abbr -a gX 'git rm -r --force --cached'
abbr -a gxc 'git rm -r --cached'
# Reset (rs)
abbr -a grs 'git reset'
abbr -a grsb 'git reset "HEAD^"'
abbr -a grsh 'git reset --hard'
abbr -a grsp 'git reset --patch'
abbr -a grss 'git reset --soft'
# Revert (rv)
abbr -a grv 'git revert'
# Stash (S)
abbr -a gS 'git stash'
abbr -a gSa 'git stash apply'
abbr -a gSd 'git stash show --patch --stat'
abbr -a gSl 'git stash list'
abbr -a gSp 'git stash pop'
abbr -a gSs 'git stash save --include-untracked'
abbr -a gSS 'git stash save --patch --no-keep-index'
abbr -a gSw 'git stash save --include-untracked --keep-index'
abbr -a gSx 'git stash drop'
# Status (s)
abbr -a gs 'git status'
abbr -a gss 'git status --short'
# Tag (t)
abbr -a gt 'git tag'
abbr -a gtl 'git tag --list'
abbr -a gts 'git tag --sign'
abbr -a gtv 'git verify-tag'
# Worktree (w)
abbr -a gw 'git worktree'
abbr -a gwa 'git worktree add'
abbr -a gwab 'git worktree add -b'
abbr -a gwc 'git-worktree-clone'
abbr -a gwl 'git worktree list'
abbr -a gwL 'git worktree lock'
abbr -a gwm 'git worktree move'
abbr -a gwp 'git worktree prune'
abbr -a gwr 'git worktree remove'
abbr -a gwR 'git worktree repair'
abbr -a gwu 'git worktree unlock'
