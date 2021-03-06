DOTFILES = $(wildcard ".fonts/**/*") \
		   $(wildcard .tmux/**/*) \
		   $(wildcard .vifm/colors/*) \
		   .vifm/vifmrc \
		   .vimrc \
		   .Xresources \
		   .profile \
		   .zshrc \
		   .latexmkrc \
		   .config/nvim/init.vim \
		   .config/nvim/coc-settings.json \
		   .config/cava/config \
		   $(wildcard .config/cmus/*) \
		   .config/gtk-3.0/gtk.css \
		   .config/htop/htoprc \
		   .config/termite/config \
		   .config/vis/config \
		   .config/i3/config \
		   .config/i3/i3blocks.conf \
		   .config/flake8 \
		   .config/compton.conf

SYSTEM_DOTFILES = $(DOTFILES:%=$(HOME)/%)
LOCAL_DOTFILES = $(DOTFILES:%=%)

all: $(LOCAL_DOTFILES)
.PHONY: $(LOCAL_DOTFILES)

test:
	echo $(DOTFILES)

$(LOCAL_DOTFILES): 
	#@if [ -z $(shell rg -i password $(HOME)/$@) ]; then echo "No password found in $@"; else exit 1; fi
	#@if [ -z $(shell rg -i secret $(HOME)/$@) ]; then echo "No secret found in $@"; else exit 1; fi
	#@if [ -z $(shell rg -i token $(HOME)/$@) ]; then echo "No token found in $@"; else exit 1; fi
	@mkdir -p $(dir $@)
	cp -r $(HOME)/$@ $@
