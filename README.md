# Steps to bootstrap a new Mac

1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

```zsh
xcode-select --install
```

2. Set up ssh key for github
[more info on generating ssh keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
[more info on adding ssh keys to github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

```zsh
ssh-keygen -t ed25519 -C "github@email.com"
```

3. Add local git config with username and email

```zsh
touch ~/.gitconfig_local
```

```toml
[user]
    name = example
    email = github@email.com
```

4. Clone repo into new hidden directory.

```zsh
# Use SSH (if set up)...
git clone git@github.com:austinhallett/dotfiles.git ~/.dotfiles

# ...or use HTTPS and switch remotes later.
git clone https://github.com/austinhallett/dotfiles.git ~/.dotfiles
```

5. Create symlinks in the Home directory to the real files in the repo.

```zsh
# There are better and less manual ways to do this;
# investigate install scripts and bootstrapping tools.

ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
```

6. Install Homebrew, followed by the software listed in the Brewfile.

```zsh
# These could also be in an install script.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/Brewfile

# ...or move to the directory first.
cd ~/.dotfiles && brew bundle
```

7. Install [FiraCode](https://github.com/tonsky/FiraCode) font for spaceship prompt

8. Create symbolic link for vscode settings

```zsh
# first remove created settings file
rm ~/Library/Application\ Support/code/User/settings.json
# create symlink
ln -s ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/code/User/settings.json
```