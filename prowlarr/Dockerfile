FROM linuxserver/prowlarr:2.7.0.5723-ls168@sha256:6660787a99b2e58203539583663c973b48979fc00ff2cb78dc0ea17429e1f6ef

# No setuid or setgid binary: the estate's pods do not yet forbid privilege escalation.
RUN find / -xdev -perm /6000 -type f -exec chmod ug-s {} +

COPY prowlarr-start /usr/local/bin/prowlarr-start

# deploy, which owns its config already; the image runs read-only as it.
USER 1000:1000
ENTRYPOINT ["/usr/local/bin/prowlarr-start"]
CMD []
