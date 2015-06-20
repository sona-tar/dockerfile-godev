FROM ubuntu
MAINTAINER sona-tar

# EVN
ENV USER_NAME      develop
ENV USER_PASS      develop
ENV USER_HOME      "/home/${USER_NAME}"
ENV ROOT_PASS      root

# root user
## app install
RUN apt-get -yq update && apt-get -yq upgrade \
     build-essential libncurses5-dev openssh-server language-pack-ja \
     zsh tmux \
     git mercurial subversion gcc \
     python-pip ruby \
     wget zip unzip curl p7zip-full xterm tree \
     grep silversearcher-ag \
     emacs24 texinfo vim rlwrap \
     firefox \
     && \
     pip install diff-highlight pygments

## ssh settings
RUN mkdir /var/run/sshd && \
     echo "root:${ROOT_PASS}" | chpasswd && \
     sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
     sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add User
RUN adduser --disabled-password --gecos "" ${USER_NAME} \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "${USER_NAME}:${USER_PASS}" | chpasswd

RUN chsh -s /bin/zsh ${USER_NAME}

# develop user
## ssh
USER ${USER_NAME}
RUN mkdir /home/${USER_NAME}/.ssh && \
     chmod 700 /home/${USER_NAME}/.ssh
# ADD id_rsa /home/${USER_NAME}/.ssh/id_rsa
# ADD config /home/${USER_NAME}/.ssh/config
# ADD authorized_keys /home/${USER_NAME}/.ssh/authorized_keys

## app
ENV PATH   "${USER_HOME}/.linuxbrew/bin:${PATH}"
RUN cd ${USER_HOME} && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
RUN ${USER_HOME}/.linuxbrew/bin/brew doctor && \
    ${USER_HOME}/.linuxbrew/bin/brew install \
           go hub global \
	   peco/peco/peco motemen/ghq/ghq sona-tar/tools/ghs tcnksm/ghr/ghr
ENV GOPATH "${USER_HOME}"
ENV PATH   "${GOPATH}/bin:${PATH}"
RUN go get github.com/mitchellh/gox && \
    go get golang.org/x/tools/cmd/gorename
RUN GOMAXPROCS=4 gox -build-toolchain
RUN mkdir -p ${HOME}/src/github.com \
             ${HOME}/bin \
	     ${HOME}/.zshrc.d \
	     ${HOME}/.vim/plugin \
	     ${HOME}/.emacs.d/plugin && \
    touch ${HOME}/.Xauthority && \
    cp ${HOME}/.linuxbrew/share/gtags/gtags.vim ${HOME}/.vim/plugin/ && \
    cp ${HOME}/.linuxbrew/share/gtags/gtags.el ${HOME}/.emacs.d/plugin/

ADD add_dir/proxy.sh ${USER_HOME}/
ADD add_dir/bin ${USER_HOME}/bin/
ADD add_dir/.tmux.conf ${USER_HOME}/
ADD add_dir/.gitconfig ${USER_HOME}/
ADD add_dir/.zshrc ${USER_HOME}/
ADD add_dir/.zshrc.d ${USER_HOME}/.zshrc.d/
ADD add_dir/.emacs.d/init.el ${USER_HOME}/.emacs.d/

# root user
USER root
RUN chown -Rf ${USER_NAME}:${USER_NAME} ${USER_HOME}
EXPOSE 22
RUN mkdir /host
CMD ["/usr/sbin/sshd", "-D"]
