FROM linuxserver/prowlarr:2.5.2.5491-ls158@sha256:91844fa2c927ad6ede5630127183cc7868b175f6223e83e6a5da1fffea2aa782

# No setuid or setgid binary: the estate's pods do not yet forbid privilege escalation.
RUN find / -xdev -perm /6000 -type f -exec chmod ug-s {} +

COPY prowlarr-start /usr/local/bin/prowlarr-start

# deploy, which owns its config already; the image runs read-only as it.
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/prowlarr-start"]
CMD []
