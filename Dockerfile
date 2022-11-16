FROM archlinux:latest

# Update the container
RUN pacman -Syy

# Install required packages
RUN pacman -S --noconfirm neovim
RUN pacman -S --noconfirm gcc    # Needed for TSInstall
RUN pacman -S --noconfirm lua    # Needed for running nvim config files
RUN pacman -S --noconfirm git    # For copying my dotfiles
RUN pacman -S --noconfirm rsync  # For copying my dotfiles

# LSP packages for python
RUN pacman -S --noconfirm python     # For running the python lsp
RUN pacman -S --noconfirm python-pip # For installing lsps at system level
RUN pacman -S --noconfirm npm        # Needed for installing some LSPs
RUN pip install python-lsp-server    # Main lsp for python

# Copy our configuration
RUN mkdir -p ~/.config/nvim
RUN git clone https://github.com/SergioQuijanoRey/dotfiles.git ~/dotfiles
RUN rsync -zaP ~/dotfiles/config_files/.config/nvim/ ~/.config/nvim/

# Install packer
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN nvim -c "source ~/.config/nvim/lua/myconf/packer.lua" || echo "Sourcing packer might fail"
RUN nvim -c "PackerSync" || echo "PackerSync might fail"

# Now that nvim is configured, go to the working dir
# A mount volume has to be set when running the container
WORKDIR /app
CMD ["nvim" "."]
