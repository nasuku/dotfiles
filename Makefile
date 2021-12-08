EXCLUDED_DOTFILES := .git .git-crypt .gitattributes .gitignore .gitmodules .ssh . ..
DOTFILES := $(addprefix ~/, $(filter-out $(EXCLUDED_DOTFILES), $(wildcard .*)))

# everything, geared towards to be run for setup and maintenance
all: \
	zsh \
	taps \
	brew \
	casks \
	fonts \
	vim \
	tmux \
	dotfiles \
	defaults \
	docker \
	kube \
	golang \
	gotools \
	pytools \
	misc

disabled: \
	harder

misc:
	# Enable HiDPI display modes (requires restart)
	bash -c 'defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled | grep 1 || sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true'
	# disable apple captive portal (seucrity issue)
	bash -c 'defaults read /Library/Preferences/SystemConfiguration/com.apple.captive.control Active | grep 0 || sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false'

brew: /usr/local/bin/brew
	brew install adr-tools
	brew install angular-cli
	brew install awscli
	brew install bash
	brew install bash-completion
	brew install bat
	brew install cdk8s
	brew install coreutils
	brew install defaultbrowser
	brew install diff-so-fancy
	brew install dupseek
	brew install esolitos/ipa/sshpass
	brew install exiftool
	brew install flake8
	brew install fzf
	brew install git
	brew install git-crypt
	brew install git-extras
	brew install golangci/tap/golangci-lint
	brew install grafana
	brew install helm
	brew install htop
	brew install hugo
	brew install jinja2-cli
	brew install jq
	brew install k9s
	brew install kubectx
	brew install kudobuilder/tap/kudo-cli
	brew install lftp
	brew install minio-mc
	brew install moreutils
	brew install mosh
	brew install n
	brew install ocrmypdf
	brew install packer
	brew install packer-completion
	brew install pipenv
	brew install pre-commit
	brew install pstree
	brew install pv
	brew install ripgrep
	brew install rsnapshot
	brew install rustup
	brew install shfmt
	brew install shyaml
	brew install staticcheck
	brew install stern
	brew install task
	brew install tealdeer
	brew install telnet
	brew install terraform
	brew install terraform-docs
	brew install tflint
	brew install tfsec
	brew install tig
	brew install tmux
	brew install tree
	brew install vim
	brew install watch
	brew install weaveworks/tap/eksctl
	brew install wget
	brew install youtube-dl
	brew install zbar # for zbarimg tool to decode barcodes from img files
	brew install zsh-autosuggestions
	brew install zsh-completions
	brew install zsh-syntax-highlighting
	brew install zstd
	brew install blackhole-2ch
	brew install crane # container management
	brew install db-browser-for-sqlite # browse sqlite databases

/usr/local/bin/brew:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew analytics off

taps: /usr/local/bin/brew
	brew tap colindean/fonts-nonfree
	brew tap cuelang/tap
	brew tap esolitos/ipa
	brew tap golangci/tap
	brew tap hashicorp/tap
	brew tap homebrew/cask
	brew tap homebrew/cask-fonts
	brew tap homebrew/cask-versions
	brew tap homebrew/core
	brew tap homebrew/services
	brew tap kudobuilder/tap
	brew tap liamg/tfsec
	brew tap mistertea/et
	brew tap octave-app/octave-app
	brew tap weaveworks/tap

golang: /usr/local/bin/brew
	# language
	brew install golang
	# awesome linter
	brew install golangci/tap/golangci-lint

casks: /usr/local/bin/brew
	brew install adobe-digital-editions
	brew install alfred
	brew install appcleaner
	brew install atext
	brew install coconutbattery
	brew install devdocs
	brew install docker
	brew install dropbox
	brew install firefox
	brew install flux
	brew install flycut
	brew install goland
	brew install graphiql
	brew install hammerspoon
	brew install iterm2
	brew install keepassxc
	brew install notion
	brew install nvalt
	brew install octave-app
	brew install osxfuse
	brew install postman
	brew install pycharm-ce
	brew install skim
	brew install slack
	brew install slate
	brew install spotify
	brew install vlc
	brew install vnc-viewer
	brew install whatsapp

fonts: /usr/local/bin/brew
	# tap homebrew-fonts to install freely available fonts
	brew tap homebrew/cask-fonts
	brew install font-anonymice-nerd-font
	brew install font-anonymous-pro
	brew install font-anonymouspro-nerd-font
	brew install font-meslo-lg-nerd-font
	brew install font-microsoft-office
	brew install font-sauce-code-pro-nerd-font
	brew install font-source-code-pro
	brew install font-victor-mono
	brew install font-victor-mono-nerd-font

bash: /usr/local/bin/brew
	# newer version of bash
	brew install bash
	brew install bash-completion
	# change shell to homebrew bash
	#bash -c 'grep /usr/local/bin/bash /etc/shells || ( echo "/usr/local/bin/bash" | sudo tee -a /etc/shells )'
	#bash -c 'dscl . -read ~/ UserShell | grep /usr/local/bin/bash || ( chsh -s /usr/local/bin/bash ) '

zsh: /usr/local/bin/brew
	@# install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
	brew install zsh-completions
	brew install zsh-syntax-highlighting
	brew install zsh-autosuggestions

ruby: \
	~/.rbenv \
	~/.rbenv/plugins/ruby-build \
	~/.rbenv/plugins/rbenv-update \
	~/.rbenv/plugins/rbenv-readline \
	~/.rbenv/plugins/rbenv-gemset

# rbenv is an amazing ruby version manager, simple, straightforward, local
~/.rbenv:
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	cd ~/.rbenv && src/configure && make -C src

# ruby-build is a repository hosting all kinds of ruby versions to install
~/.rbenv/plugins/ruby-build:
	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# rbenv-update allows updating rbenv plugins easily
~/.rbenv/plugins/rbenv-update:
	git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update

# rbenv-readline does the right thing when it comes to linking a brew installed readline to ruby
~/.rbenv/plugins/rbenv-readline:
	git clone git://github.com/tpope/rbenv-readline.git ~/.rbenv/plugins/rbenv-readline

# rbenv-gemset allows managing project specific set of gems
~/.rbenv/plugins/rbenv-gemset:
	git clone git://github.com/jf/rbenv-gemset.git ~/.rbenv/plugins/rbenv-gemset

vim: \
	vim-itself \
	vim-plugins

vim-itself: /usr/local/bin/brew
	# for mac
	brew install macvim
	# create vim directories
	mkdir -p ~/.vim/tmp/{backup,swap,undo}
	mkdir -p ~/.backup/vim/undo

vim-plugins: \
	~/.vim/autoload/plug.vim
	# disable colorscheme for installing plugins to a temporary .vimrc
	sed 's/colorscheme/"colorscheme/' .vimrc > /tmp/.vimrc
	# install plugins with temporary vimrc
	vim -u /tmp/.vimrc +PlugInstall +qall
	-rm /tmp/.vimrc

~/.vim/autoload/plug.vim:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

tmux:  /usr/local/bin/brew ~/.tmux.conf
	brew install tmux

defaults: \
	defaults-Dock \
	defaults-NSGlobalDomain \
	defaults-trackpad \
	defaults-Calendar \
	defaults-iterm
	# Show remaining battery time; hide percentage
	defaults write com.apple.menuextra.battery ShowPercent -string "NO"
	defaults write com.apple.menuextra.battery ShowTime -string "YES"
	# Enable AirDrop over Ethernet and on unsupported Macs running Lion
	defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
	# Automatically open a new Finder window when a volume is mounted
	defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
	defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
	# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	# Disable the warning when changing a file extension
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
	# Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
	# Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
	# Automatically illuminate built-in MacBook keyboard in low light
	defaults write com.apple.BezelServices kDim -bool true
	# Turn off keyboard illumination when computer is not used for 5 minutes
	defaults write com.apple.BezelServices kDimTime -int 300
	# Save screenshots to the desktop
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"
	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true
	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"
	# Hide all desktop icons because who need 'em'
	defaults write com.apple.finder CreateDesktop -bool false
	# Enable HiDPI display modes (requires restart)
	# bash -c 'defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled | grep 1 || sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true'
	# Finder: disable window animations and Get Info animations
	defaults write com.apple.finder DisableAllAnimations -bool true
	# Finder: show hidden files by default
	defaults write com.apple.Finder AppleShowAllFiles -bool true
	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true
	# Empty Trash securely by default
	defaults write com.apple.finder EmptyTrashSecurely -bool false
	# Require password immediately after 5 seconds on sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 5
	# Only use UTF-8 in Terminal.app
	defaults write com.apple.terminal StringEncodings -array 4
	# Show the ~/Library folder
	chflags nohidden ~/Library
	# disable apple captive portal (seucrity issue)
	#bash -c 'defaults read /Library/Preferences/SystemConfiguration/com.apple.captive.control Active | grep 0 || sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false'
	# setup Quad9 DNS
	#networksetup -setdnsservers Wi-Fi 9.9.9.9
	# Keep this bit last
	# Kill affected applications
	for app in Safari Finder Mail SystemUIServer; do killall "$$app" >/dev/null 2>&1; done
	# Re-enable subpixel aliases that got disabled by default in Mojave
	defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

defaults-Dock:
	# Enable the 2D Dock
	defaults write com.apple.dock no-glass -bool true
	# Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool false
	# Make Dock icons of hidden applications translucent
	defaults write com.apple.dock showhidden -bool true
	# Enable highlight hover effect for the grid view of a stack (Dock)
	defaults write com.apple.dock mouse-over-hilte-stack -bool true
	# Enable spring loading for all Dock items
	defaults write enable-spring-load-actions-on-all-items -bool true
	# Show indicator lights for open applications in the Dock
	defaults write com.apple.dock show-process-indicators -bool true
	# Don’t animate opening applications from the Dock
	defaults write com.apple.dock launchanim -bool false
	# clean up right side (persistent)
	-defaults delete com.apple.dock persistent-others
	# left side
	defaults write com.apple.dock orientation -string "left"
	defaults write com.apple.dock magnification -int 1
	# and add these folders
	defaults write com.apple.dock persistent-others -array-add "$$(echo '{"tile-type": "directory-tile", "tile-data": {"displayas": 0, "file-type":2, "showas":3, "file-label":"Dropbox", "file-data":{"_CFURLString":"file:///Users/Suresh/Dropbox/","_CFURLStringType":15}}}' | plutil -convert xml1 - -o -)";
	defaults write com.apple.dock persistent-others -array-add "$$(echo '{"tile-type": "directory-tile", "tile-data": {"displayas": 1, "file-type":2, "showas":1, "file-label":"Desktop", "file-data":{"_CFURLString":"file:///Users/Suresh/Desktop/","_CFURLStringType":15}}}' | plutil -convert xml1 - -o -)";
	defaults write com.apple.dock persistent-others -array-add "$$(echo '{"tile-type": "directory-tile", "tile-data": {"displayas": 0, "file-type":2, "showas":3, "file-label":"Downloads", "file-data":{"_CFURLString":"file:///Users/Suresh/Downloads/","_CFURLStringType":15}}}' | plutil -convert xml1 - -o -)";
	# restart dock
	killall Dock

defaults-NSGlobalDomain:
	# Locale
	defaults write NSGlobalDomain AppleLocale -string "en_US"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
	defaults write NSGlobalDomain AppleMetricUnits -bool true
	# 24-Hour Time
	defaults write NSGlobalDomain AppleICUForce12HourTime -bool false
	# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
	# Enable subpixel font rendering on non-Apple LCDs
	defaults write NSGlobalDomain AppleFontSmoothing -int 2
	# Disable menu bar transparency
	defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
	# Enable press-and-hold for keys
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	# Set a blazingly fast keyboard repeat rate (1 = fastest for macOS high sierra, older versions support 0)
	defaults write NSGlobalDomain KeyRepeat -int 2
	# Decrase the time to initially trigger key repeat
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	# Enable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
	# Disable window animations
	defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
	# Increase window resize speed for Cocoa applications
	defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
	# Disable smart quotes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
	# Disable smart dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	# Trackpad: enable tap to click for this user and for the login screen
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	# Finder: show all filename extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults-trackpad:
	# Trackpad settings
	defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1
	defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
	defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0
	defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
	defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1
	defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -int 0
	defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
	defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
	defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingersRightClick -int 0
	defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
	defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
	defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -int 0

defaults-Calendar:
	# Show week numbers (10.8 only)
	defaults write com.apple.iCal "Show Week Numbers" -bool true
	# Show 7 days
	defaults write com.apple.iCal "n days of week" -int 7
	# Week starts on monday
	defaults write com.apple.iCal "first day of week" -int 1
	# Show event times
	defaults write com.apple.iCal "Show time in Month View" -bool true

defaults-iterm:
	defaults import com.googlecode.iterm2 prefs/com.googlecode.iterm2.plist

dotfiles: $(DOTFILES)

~/.ssh/config:
	cp ssh_config ~/.ssh/config

$(DOTFILES):
	cd ~ && ln -sv dotfiles/$(notdir $@) $@

~/.kube/bash_completion:
	kubectl completion bash > ~/.kube/bash_completion

docker: /usr/local/bin/brew
	brew install docker

kube: /usr/local/bin/brew
	brew install kubernetes-cli

# Here is a comprehensive guide: https://github.com/drduh/macOS-Security-and-Privacy-Guide
# The following settings implement some basic security measures
harder: \
	harder-dns-resolver
	# Enable the firewall
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
	# Enable logging on the firewall
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
	# Enable stealth mode (computer does not respond to PING or TCP connections on closed ports)
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
	# Prevent built-in software as well as code-signed, downloaded software from being whitelisted automatically
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
	# Restart the firewall (this should remain last)
	-sudo pkill -HUP socketfilterfw
	# Enable touch id for sudo (if available)
	-@test -f /usr/lib/pam/pam_tid.so* && (grep pam_tid.so /etc/pam.d/sudo || sudo /usr/local/bin/gsed -e '2iauth       sufficient     pam_tid.so' -i /etc/pam.d/sudo)

harder-dns-resolver:
	#brew install knot-resolver
	#cp -v ~/dotfiles/etc/kresd/config /usr/local/etc/kresd/config
	#sudo brew services restart knot-resolver

gotools: golang
	# cleans up files with messy ascii codes
	go get github.com/lunixbochs/vtclean/vtclean
	go get github.com/nasuku/commandcast
	go get github.com/mattn/goreman

pytools:
	pip3 install -U pdf.tocgen
