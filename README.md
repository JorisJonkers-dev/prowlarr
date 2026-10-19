# prowlarr

[Prowlarr](https://prowlarr.com) as the estate runs it: the
[linuxserver.io](https://www.linuxserver.io) image, run as `deploy` (1000:1000)
under a read-only root filesystem, with
[flaresolverr](https://github.com/JorisJonkers-dev/flaresolverr) beside it as a
sidecar. deploy-kit delivers them as the Project `prowlarr`.

## What the image changes

`prowlarr/Dockerfile` names `USER 1000:1000`, clears every setuid and setgid
bit, and starts Prowlarr directly rather than through s6, which wants a `/run`
the pod does not give it. The start script points `TMPDIR` at `/tmp`, since the
image's own sits below `/run`.

## Running it

`deploy/prowlarr.project.yml` and `deploy/env/` declare the Project:
- **VPN:** prowlarr attaches to the platform's VPN, egress only. flaresolverr
  shares its pod and so its tunnel and exit address, which Cloudflare's
  clearance is tied to. prowlarr reaches it on `localhost:8191`.
- **config:** a claim the platform's `file-backup` copies nightly.
- **`/tmp`:** writable for prowlarr and for flaresolverr's Chrome profile;
  sidecars mount the Process's writable paths.

## Versions

This repository's version is Prowlarr's first three numbers: release `v2.5.2`
runs Prowlarr 2.5.2.5491. A fragment's version is `x.y.z`, so the fourth, a
build number, and linuxserver's `-lsN` rebuilds ship with the next release.
Renovate opens a pull request for each update. A minor or patch update merges
itself once `Pipeline Complete` passes; a major release waits for approval on
the Dependency Dashboard. When the `FROM` tag in `prowlarr/Dockerfile` names a
new version on `main`, `release.yml` releases it and publishes the image and
the Intent Fragment.

`flaresolverr/Dockerfile` is not built. It names the flaresolverr image by
digest, which `publish.yml` locks for the sidecar, and Renovate moves it.

`scripts/smoke-test.sh` starts the image restricted and waits until it serves;
CI runs it on every change.

## Licence

This repository's own files are MIT: see [LICENSE](LICENSE). Prowlarr is
GPL-3.0, as is the linuxserver.io image built from it.
