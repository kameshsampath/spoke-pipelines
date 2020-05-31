FROM centos:centos8

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /bin/tini
ADD utils/entrypoint.sh /bin/entrypoint

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
  dnf config-manager --add-repo https://releases.ansible.com/ansible-runner/ansible-runner.el8.repo

RUN dnf -y update && \
   dnf install -y epel-release && \
   dnf install -y ansible ansible-runner bubblewrap sudo rsync openssh-clients sshpass 

RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8

# In OpenShift, container will run as a random uid number and gid 0. Make sure things
# are writeable by the root group.
RUN mkdir -p /runner/inventory /runner/project /runner/artifacts /runner/.ansible/tmp && \
	chmod -R g+w /runner && chgrp -R root /runner && \
	chmod g+w /etc/passwd && chmod +x /bin/entrypoint

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

VOLUME /runner

ENTRYPOINT ["entrypoint"]
CMD ["ansible-runner", "run", "/runner"]