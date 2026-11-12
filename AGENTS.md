# Agents

Guidance for any coding agent working in this repository.

- Agent contract: [CLAUDE.md](CLAUDE.md), which points at [the estate contract](https://github.com/JorisJonkers-dev/workspace/blob/main/CLAUDE.md).
- What this repository holds: the Prowlarr image (`prowlarr/Dockerfile`, `prowlarr/prowlarr-start`), the flaresolverr sidecar image, and the Project declaration (`deploy/prowlarr.project.yml`). See [README.md](README.md).

## Build and test

```bash
shellcheck scripts/*.sh prowlarr/prowlarr-start
docker build -t prowlarr:ci prowlarr
scripts/smoke-test.sh prowlarr:ci
```

CI (`.github/workflows/ci.yml`) runs the same lint, image build and restricted smoke test; the `Pipeline Complete` check gates merges.
