FROM elixir:latest
RUN apt-get update && apt-get install -y build-essential automake autoconf git squashfs-tools ssh-askpass sudo
COPY ./fwup_1.3.0_amd64.deb /var/tmp/fwup_1.3.0_amd64.deb
RUN apt install /var/tmp/fwup_1.3.0_amd64.deb
RUN apt-get install -y libssl-dev libncurses5-dev bc m4 unzip cmake python
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN mix local.hex && mix local.rebar

# Still have to run this locally - need to eventually figure this out
#RUN mix archive.install hex nerves_bootstrap
