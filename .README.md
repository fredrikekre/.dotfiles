# .dotfiles

Configuration files for syncing between machines. See https://www.atlassian.com/git/tutorials/dotfiles for the idea.

## Installation

1. Clone the repo:
   ```
   $ git clone --bare https://github.com/fredrikekre/.dotfiles.git $HOME/.dotfiles.git
   ```

2. Define a temporary `dotfiles` alias:
   ```
   $ alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
   ```

3. Check out the files:
   ```
   $ dotfiles checkout
   ```

4. Add the following to the top of `.bashrc`
   ```
   # Include cross-system common parts from .dotfiles.git repo
   if [ -f ~/.bashrc.dotfiles ]; then
       . ~/.bashrc.dotfiles
   fi
   ```

5. Configure the new local repo to hide untracked files
   ```
   $ dotfiles config --local status.showUntrackedFiles no
   ```

6. Reboot the shell
