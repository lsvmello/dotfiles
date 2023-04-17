function git-worktree-clone --argument git_url --argument folder_name
  if test -z $git_url
    echo "Missing argument.\nUsage: worktree-clone <git_url>"
    return 1
  end

  if string match -riq '\/(?<folder>\w+)\.git' $git_url
    if test -z $folder_name
      set folder_name $folder
    end
    mkdir $folder_name && cd $folder_name
    git clone --bare $git_url .bare
    echo "gitdir: ./.bare" > .git
    # Explicitly sets the remote origin fetch so we can fetch remote branches
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    # Gets all branches from origin
    git fetch origin
  else
    echo "'$git_url' is not a valid git repository uri"
    return 1
  end
end
