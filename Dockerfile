# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM ubuntu:18.04
LABEL maintainer "Yuki Tsuchida(gahaku) <d@gahaku.tech>"
# ------------------------------------------------------------------------------
# Install base
RUN apt-get update &&\
    apt-get install -y sudo locales curl g++ git vim libreadline-dev libpq-dev sqlite3 libsqlite3-dev lsof bzip2 build-essential libssl-dev zlib1g-dev autoconf bison libyaml-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev&& \
    curl https://cli-assets.heroku.com/install.sh | sh &&\
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# ------------------------------------------------------------------------------
# Add users
RUN useradd -G sudo -m -s /bin/bash lit_users&&\
    echo "lit_users ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/lit_users&&\
    echo 'root:kana.kobayashi' | chpasswd
USER lit_users

# ------------------------------------------------------------------------------
# Install Ruby2.5.1
RUN git clone https://github.com/sstephenson/rbenv.git /home/lit_users/.rbenv&&\
    git clone https://github.com/sstephenson/ruby-build.git /home/lit_users/.rbenv/plugins/ruby-build

ENV PATH /home/lit_users/.rbenv/bin:$PATH
RUN rbenv install 2.5.1&&\
    rbenv global 2.5.1&&\
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc &&\
    . ~/.bashrc

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 4567

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /home/lit_users/workspace
VOLUME /home/lit_users/workspace
WORKDIR /home/lit_users/workspace

ENTRYPOINT ["/bin/bash"]