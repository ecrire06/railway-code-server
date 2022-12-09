# Start from the code-server Debian base image
# To Update your code-server version, modify the version number on line 2 in your Dockerfile. See the [list of tags](https://hub.docker.com/r/codercom/code-server/tags?page=1&ordering=last_updated) for the latest version.
FROM codercom/code-server:4.8.3

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
RUN code-server --install-extension pkief.material-icon-theme
RUN code-server --install-extension CoenraadS.bracket-pair-colorizer-2
RUN code-server --install-extension oderwat.indent-rainbow
RUN code-server --install-extension wakatime.vscode-wakatime
RUN code-server --install-extension ms-python.python

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
# ADD https://api.github.com/repos/$USER/$REPO/git/refs/heads/$BRANCH version.json
# RUN git clone -b $BRANCH https://github.com/$USER/$REPO.git $GIT_HOME/


