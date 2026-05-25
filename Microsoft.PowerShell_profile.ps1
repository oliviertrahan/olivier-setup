# Custom alias to open Neovim with WorkStart
function nvimW {
    nvim +WorkStart
}

function powr {
    if (Test-Path $PROFILE) {
        . $PROFILE
        Write-Host "Profile reloaded."
    }
    else {
        Write-Warning "Profile not found: $PROFILE"
    }
}

$bash_path = "C:\msys64\usr\bin\bash.exe"

#Manual bash invoker
function b {
  param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Args)
  $cmd = $Args -join ' '
  & $bash_path -lc "source ~/.bashrc >/dev/null 2>&1; $cmd"
}


# git configs
function Setup-GitPersonal {
    param(
        [switch]$Global
    )
    if ($Global) {
        Write-Host "Setting up global git config"
        git config --global user.name "oliviertrahan"
        git config --global user.email "trahan.olivier@gmail.com"
    } else {
        Write-Host "Setting up local git config"
        git config user.name "oliviertrahan"
        git config user.email "trahan.olivier@gmail.com"
    }
}

function git_get_main_branch {
    if (git show-ref --quiet refs/heads/main) {
        return "main"
    } else {
        return "master"
    }
}

function fuzzy_find_staged_files {
    git --no-pager diff --name-only --cached | fzf
}

function fuzzy_find_staged_file_directories {
    git diff --name-only --cached |
        ForEach-Object { Split-Path $_ -Parent } |
        Sort-Object -Unique |
        fzf
}


function fuzzy_find_modified_files {
    git ls-files -m --others --exclude-standard | fzf
}

function fuzzy_find_modified_file_directories {
    git ls-files -m --others --exclude-standard |
        ForEach-Object { Split-Path $_ -Parent } |
        Sort-Object -Unique |
        fzf
}

function fuzzy_find_cleanable_files {
    git ls-files --others --exclude-standard | fzf
}

function fuzzy_find_cleanable_file_directories {
    git ls-files --others --exclude-standard |
        ForEach-Object { Split-Path $_ -Parent } |
        Sort-Object -Unique |
        fzf
}

function git_select_from_latest_branch {
    git --no-pager branch -l --sort=-committerdate | fzf
}

function git_select_from_latest_origin_branch {
    git --no-pager branch -lr --sort=-committerdate | fzf
}

function git_select_from_oldest_branch {
    git --no-pager branch -l --sort=committerdate | fzf
}

function add_review_branch {
    git_select_from_latest_origin_branch |
        ForEach-Object {
            $branch = $_ -replace '^[ \t]*origin/', ''
            $worktree = "../$((Split-Path -Leaf (Get-Location)))" + "-review"
            git worktree add -f $worktree $branch
        }
}


# Functions for commands with arguments
function gs { git status @args }
function ga { git add @args }
function gf { git fetch @args }
function gmerge { git merge @args }
function grb { git rebase @args }
function gpf { git push --force-with-lease @args }
# function gP { git pull @args }
function gup { git pull @args }
function gd { git diff @args }
function gdt { git difftool @args }
function gdca { git diff --cached @args }
function gcp { git cherry-pick @args }
function gco { git checkout @args }


# Remove builtin alias of gcm and replace with our own
function global:gcm {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    $mainBranch = git_get_main_branch
    git checkout $mainBranch @Args
}
function gcb { git checkout -b @args }
function grh { git reset @args }
function grhh { git reset --hard @args }
function grevm { git checkout origin/$(git_get_main_branch) -- @args }
function glog { git log @args }
function gaa { git add --all @args }
function gbd { git branch -d @args }
function gbD { git branch -D @args }
function gcom { git commit @args }
function gcomm { git commit -m @args }
function gsta { git stash @args }
function gstc { git stash clear @args }
function gstd { git stash drop @args }
function gstl { git stash list @args }
function gstp { git stash pop @args }
function grbc { git rebase --continue @args }
function gcleanall { git clean -fd @args }
function gsquash {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )
    git fetch
    $mainBranch = git_get_main_branch
    git reset --soft "origin/$mainBranch" @Args
}


# Remove builtin alias of gp and replace with our own
function gpush {
    param(
        [Parameter(Position=0)]
        [string]$Message,
        [Parameter(Position=1, ValueFromRemainingArguments=$true)]
        [string[]]$ExtraFlags
    )
    if ($PSBoundParameters.ContainsKey('Message') -and $ExtraFlags.Count -eq 0) {
        git commit -m "$Message"; if ($LASTEXITCODE -eq 0) { git push }
    } elseif ($PSBoundParameters.ContainsKey('Message') -and $ExtraFlags.Count -gt 0) {
        git commit -m "$Message" $ExtraFlags; if ($LASTEXITCODE -eq 0) { git push }
    } else {
        git push
    }
}

function ai {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )
    aichat -e ($Args -join ' ')
}

# Git fuzzy finder aliases converted to PowerShell functions and aliases
function gsfs { fuzzy_find_staged_files }

function gmfs { fuzzy_find_modified_files }

function gaf { fuzzy_find_modified_files | ForEach-Object { git add $_ } }

function gafd { fuzzy_find_modified_file_directories | ForEach-Object { git add $_ } }

function grhf { fuzzy_find_staged_files | ForEach-Object { git reset $_ } }

function grhfd { fuzzy_find_staged_file_directories | ForEach-Object { git reset $_ } }

function grhhf { fuzzy_find_modified_files | ForEach-Object { git reset --hard $_ } }

function grhhfd { fuzzy_find_modified_file_directories | ForEach-Object { git reset --hard $_ } }

function gcof { fuzzy_find_modified_files | ForEach-Object { git checkout $_ } }

function gcofd { fuzzy_find_modified_file_directories | ForEach-Object { git checkout $_ } }

function grevmf { fuzzy_find_modified_files | ForEach-Object { git checkout "origin/$(git_get_main_branch)" -- $_ } }

function grevmfd { fuzzy_find_staged_file_directories | ForEach-Object { git checkout "origin/$(git_get_main_branch)" -- $_ } }

function grevb { git_select_from_latest_branch | ForEach-Object { git checkout $_ -- } }

function grevob { git_select_from_latest_origin_branch | ForEach-Object { git checkout $_ -- } }

function gdf { fuzzy_find_modified_files | ForEach-Object { git diff $_ } }

function gdmf { fuzzy_find_modified_files | ForEach-Object { git diff "origin/$(git_get_main_branch):$_" $_ } }

function gdaf { fuzzy_find_staged_files | ForEach-Object { git diff $_ } }

function gdfd { fuzzy_find_modified_file_directories | ForEach-Object { git diff $_ } }

function gdtf { fuzzy_find_modified_files | ForEach-Object { git difftool $_ } }

function gdtfd { fuzzy_find_modified_file_directories | ForEach-Object { git difftool $_ } }

function gcbf { git_select_from_latest_branch | ForEach-Object { $_ -replace '^[ \t]*' } | ForEach-Object { git checkout $_ } }

function gmf { git_select_from_latest_branch | ForEach-Object { git merge $_ } }

function gmof { git_select_from_latest_origin_branch | ForEach-Object { git merge $_ } }

function grbf { git_select_from_latest_branch | ForEach-Object { git rebase $_ } }

function grbof { git_select_from_latest_origin_branch | ForEach-Object { $_ -replace '^[ \t]*origin/' } | ForEach-Object { git rebase $_ } }

function grbonf { git_select_from_latest_origin_branch | ForEach-Object { $_ -replace '^[ \t]*origin/' } | ForEach-Object { git rebase --onto "origin/$(git_get_main_branch)" $_ } }

function gcbof { git_select_from_latest_origin_branch | ForEach-Object { $_ -replace '^[ \t]*origin/' } | ForEach-Object { git checkout $_ } }

function gcleanf { fuzzy_find_cleanable_files | ForEach-Object { git clean -fd $_ } }

function gcleanfd { fuzzy_find_cleanable_file_directories | ForEach-Object { git clean -fd $_ } }

function gbDf {
    git_select_from_oldest_branch | Tee-Object -FilePath "$HOME/branch.txt" | ForEach-Object { git branch -D $_ }
    Get-Content "$HOME/branch.txt" | ForEach-Object { git push origin --delete $_ }
    Remove-Item "$HOME/branch.txt"
}

function gstaf { fuzzy_find_modified_files | ForEach-Object { git stash push $_ } }

function gstafd { fuzzy_find_modified_file_directories | ForEach-Object { git stash push $_ } }

function grmf { fuzzy_find_modified_files | ForEach-Object { git rm $_ } }

function grmfd { fuzzy_find_modified_file_directories | ForEach-Object { git rm $_ } }

function gsquashb {
    git fetch
    $branch = git_select_from_latest_origin_branch
    if ($branch) {
        git reset --soft "origin/$branch"
    }
}


$localScriptPath = "$HOME\Microsoft.PowerShell_profile_extra.ps1"

if (Test-Path $localScriptPath) {
    . $localScriptPath
}
