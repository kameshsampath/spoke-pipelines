FROM registry.fedoraproject.org/f31/python3

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /bin/tini
ADD bin/entrypoint.sh /bin/entrypoint

USER root

RUN dnf -y update \
    && dnf install -y dnf-plugins-core

RUN dnf config-manager \
  --add-repo https://releases.ansible.com/ansible-runner/ansible-runner.el8.repo \
   && dnf install -y bubblewrap sshpass

# In OpenShift, container will run as a random uid number and gid 0. Make sure things
# are writeable by the root group.
RUN mkdir -p /runner/inventory /runner/project /runner/artifacts /runner/.ansible/tmp \
  && chmod -R g+w /runner && chgrp -R root /runner \
  && chmod g+w /etc/passwd \
  && chmod +x /usr/bin/tini \
  && chmod +x /usr/bin/entrypoint

VOLUME /runner/inventory
VOLUME /runner/project
VOLUME /runner/artifacts
VOLUME /runner

RUN pip3 install ansible-runner ansible openshift

USER 1001

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV RUNNER_BASE_COMMAND=ansible-playbook
ENV HOME=/runner

ENTRYPOINT ["entrypoint"]
CMD ["ansible-runner", "run", "/runner"]