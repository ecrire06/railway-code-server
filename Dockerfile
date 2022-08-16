# Start from the code-server Debian base image
# To Update your code-server version, modify the version number on line 2 in your Dockerfile. See the [list of tags](https://hub.docker.com/r/codercom/code-server/tags?page=1&ordering=last_updated) for the latest version.
FROM codercom/code-server:4.5.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
# see https://rclone.org/install/ for other install options
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# To check the name of extension, VSCode -> Extension -> More Info -> Identifier
# Check: [Command line extension management](https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management)
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension equinusocio.vsc-material-theme
RUN code-server --install-extension pkief.material-icon-theme
RUN code-server --install-extension formulahendry.auto-rename-tag
RUN code-server --install-extension solnurkarim.html-to-css-autocompletion
RUN code-server --install-extension ecmel.vscode-html-css
RUN code-server --install-extension pranaygp.vscode-css-peek
RUN code-server --install-extension mrmlnc.vscode-autoprefixer
RUN code-server --install-extension CoenraadS.bracket-pair-colorizer-2
RUN code-server --install-extension oderwat.indent-rainbow
RUN code-server --install-extension ritwickdey.LiveServer

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# You can add custom software and dependencies for your environment here. Some examples:

# RUN sudo apt-get install -y build-essential
# RUN COPY myTool /home/coder/myTool

# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]

# GitHub Repository Clone - ecrire06 personal blog
RUN git clone https://github.com/ecrire06/ecrire06.git
RUN cd ecrire06
# RUN git config user.name "ecrire06"
# RUN git config user.email "juneha2002@gmail.com"

