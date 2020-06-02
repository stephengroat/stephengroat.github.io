# sekey config
export SSH_AUTH_SOCK=$HOME/.sekey/ssh-agent.ssh

# macOS Dock config
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide -bool true
killall Dock
