EXCLUDED_DOTFILES := .git .git-crypt .gitattributes .gitignore .gitmodules .ssh . ..
DOTFILES := $(addprefix ~/, $(filter-out $(EXCLUDED_DOTFILES), $(wildcard .*)))

# everything, geared towards to be run for setup and maintenance
all: \
	zsh \
	brew \
	casks \
	fonts \
	dotfiles \
	mise-packages  \
	defaults-iterm

disabled: \
	powerlevel10k \
	pytools \
	gotools \
	tmux \
	vim

unused-brew:
	#brew install adr-tools
	#brew install angular-cli
	#brew install awscli
	#brew install bash
	#brew install bash-completion
	#brew install cdk8s
	#brew install defaultbrowser
	#brew install dupseek
	#brew install esolitos/ipa/sshpass
	#brew install flake8
	#brew install golangci/tap/golangci-lint
	#brew install grafana
	#brew install helm
	#brew install htop
	#brew install hugo
	#brew install jinja2-cli
	#brew install kubectx
	#brew install kudobuilder/tap/kudo-cli
	#brew install lftp
	#brew install minio-mc
	#brew install mosh
	#brew install ocrmypdf
	#brew install packer
	#brew install packer-completion
	#brew install pipenv
	#brew install pre-commit
	#brew install pstree
	#brew install python-tabulate
	#brew install pv
	#brew install rustup
	#brew install shfmt
	#brew install shyaml
	#brew install staticcheck
	#brew install stern
	#brew install task
	#brew install tealdeer
	#brew install telnet
	#brew install terraform
	#brew install terraform-docs
	#brew install tflint
	#brew install tfsec
	#brew install tig
	#brew install tmux
	#brew install tree
	#brew install weaveworks/tap/eksctl
	#brew install wget
	#brew install blackhole-2ch
	#brew install sqlite-utils
	#brew install vegeta
	#brew install pdsh # like commandcast

brew: /opt/homebrew/bin/brew
	brew install bat
	brew install coreutils # gdate etc
	brew install diff-so-fancy
	brew install exiftool
	brew install fzf
	brew install git
	brew install git-crypt
	brew install git-extras
	brew install goreman
	brew install jq
	brew install k9s
	brew install k3d
	brew install moreutils # vidir etc
	brew install n
	brew install ollama
	brew install ripgrep
	brew install rsnapshot
	brew install watch
	brew install yt-dlp
	brew install zbar # for zbarimg tool to decode barcodes from img files
	brew install zsh-autosuggestions
	brew install zsh-completions
	brew install zsh-syntax-highlighting
	brew install zstd
	brew install crane # container management
	brew install db-browser-for-sqlite # browse sqlite databases
	brew install neovim
	brew install podman # extra docker
	brew install kind # extra k3d

/opt/homebrew/bin/brew:
	 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew analytics off

taps: /opt/homebrew/bin/brew
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

unused-casks: /opt/homebrew/bin/brew
	#brew install adobe-digital-editions
	#brew install alfred
	#brew install appcleaner
	#brew install atext
	#brew install coconutbattery
	#brew install devdocs
	#brew install docker
	#brew install dropbox
	#brew install firefox
	#brew install flux
	#brew install flycut
	#brew install goland
	#brew install graphiql
	#brew install notion
	#brew install nvalt
	#brew install octave-app
	#brew install macfuse
	#brew install postman
	#brew install pycharm-ce
	#brew install slack
	#brew install slate
	#brew install vlc
	#brew install vnc-viewer
	#brew install whatsapp
	#brew install utm

casks: /opt/homebrew/bin/brew
	brew install hammerspoon
	brew install iterm2
	brew install keepassxc
	brew install skim
	brew install spotify
	brew install vagrant
	brew install homebrew/cask/docker

fonts: /opt/homebrew/bin/brew
	# brew install font-anonymice-nerd-font
	# brew install font-anonymous-pro
	brew install font-iosevka-nerd-font
	brew install font-hack-nerd-font

zsh: /opt/homebrew/bin/brew
	# install oh-my-zsh
	# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
	# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	brew install zinit
	brew install zsh-completions
	brew install zsh-syntax-highlighting
	brew install zsh-autosuggestions

vim: \
	vim-itself \
	vim-plugins

vim-itself: /opt/homebrew/bin/brew
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

tmux:  /opt/homebrew/bin/brew ~/.tmux.conf
	brew install tmux

defaults-iterm:
	defaults import com.googlecode.iterm2 prefs/com.googlecode.iterm2.plist

dotfiles: $(DOTFILES)

~/.ssh/config:
	cp ssh_config ~/.ssh/config

$(DOTFILES):
	cd ~ && ln -sv dotfiles/$(notdir $@) $@

~/.kube/bash_completion:
	kubectl completion bash > ~/.kube/bash_completion

gotools: golang
	# cleans up files with messy ascii codes
	# go install github.com/lunixbochs/vtclean/vtclean@latest
	#go install github.com/nasuku/commandcast@latest
	# go install github.com/mattn/goreman@latest
	# like uniq -c but easier to read
	# go install github.com/karrick/histogram@latest

pytools:
	pip3 install -U pdf.tocgen
	pip3 install -U sqlite-utils

mise-packages: brew
	mise use -g go
	mise use -g python

powerlevel10k:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
