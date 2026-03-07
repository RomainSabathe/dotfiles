---
name: container-debug
description: "Debug and test code that must run inside a Docker/Podman container. Use when the project has a Dockerfile or container setup and you need to build an image, run a server, hit endpoints, or inspect logs to reproduce and fix errors. Triggers when (1) the user says to test/debug via Docker or Podman, (2) an error can only be reproduced inside a container, (3) the project has a Dockerfile and the code under test depends on container-specific dependencies (Playwright, system libs, etc.)."
---

# Container Debug

Workflow for building, running, and debugging applications inside Docker/Podman containers.

## Workflow

1. Discover container setup (Dockerfile, compose files, helper scripts)
2. Build the image, fix build failures
3. Run the container with the right mounts/ports
4. Hit the endpoint or trigger the code path
5. Inspect logs for the actual error
6. Fix the code, re-test (no rebuild needed if bind-mounted)

## Step 1: Discover Container Setup

Look for `Dockerfile`, `compose.yaml`, `docker-compose.yml`, and helper scripts:

```
Glob: Dockerfile*, *compose*, **/docker*.py
```

Read the Dockerfile to understand:
- Base image and system dependencies
- How the app is installed (pip, uv, poetry, etc.)
- `WORKDIR`, `CMD`, `ENTRYPOINT`
- Whether a `.dockerignore` exists (it can silently exclude files needed at build time)

## Step 2: Build the Image

Prefer `podman` over `docker` unless the project explicitly uses Docker.

```bash
podman build -t <image-name> -f Dockerfile .
```

### Common build failures

**Missing files due to `.dockerignore`**: Check `.dockerignore` for overly broad patterns (e.g. `*.md` excluding `README.md` needed by the build system). Fix with negation patterns (`!README.md`).

**Package build before source is copied**: If the Dockerfile copies only dependency files first (for layer caching) then runs install, the build tool may need source files too. Fix by splitting into two steps:

```dockerfile
COPY pyproject.toml uv.lock README.md ./
RUN uv sync --frozen --no-dev --no-install-project   # deps only

COPY . .
RUN uv sync --frozen --no-dev                         # install project
```

## Step 3: Run the Container

Key flags:
- `--rm` — auto-cleanup
- `-d` — detach (run in background)
- `--name <name>` — for easy log inspection and cleanup
- `--network host` — simplest networking, exposes ports directly
- `-v "$(pwd):/code:z"` — bind-mount source for live code changes (`:z` for SELinux)

```bash
podman run --rm -d --name debug-container --network host \
  -v "$(pwd):/code:z" <image-name> \
  bash -c "cd /code && <command>"
```

### Installed package vs bind-mounted source

When the Dockerfile installs the package into a venv (e.g. `uv sync`, `pip install -e .`), the container's entry point runs the **installed** copy, not the bind-mounted source. To test live code changes, reinstall from the mount before running:

```bash
bash -c "cd /code && uv sync --frozen --no-dev && <entry-point>"
```

Or use `python -m <module>` / `uvicorn <module>:app` directly from `/code` if applicable.

## Step 4: Test the Endpoint

Wait for the server to start, then hit it:

```bash
sleep 2 && curl -s http://127.0.0.1:<port>/
```

If you get `Internal Server Error` or an empty response, check container logs.

## Step 5: Inspect Logs

```bash
podman logs <container-name> 2>&1 | tail -40
```

Read the full traceback. Common container-specific errors:
- **`DetachedInstanceError` (SQLAlchemy)**: Accessing a lazy-loaded relationship after the session is closed. Fix by eager-loading with `selectinload()` or `joinedload()`.
- **File not found**: Path differences between host and container (`WORKDIR` vs bind mount path).
- **Permission denied**: SELinux on Fedora/RHEL — use `:z` suffix on volume mounts.

## Step 6: Fix and Re-test

If the source is bind-mounted, just edit the file on the host and restart:

```bash
podman stop <container-name>
podman run --rm -d --name <container-name> --network host \
  -v "$(pwd):/code:z" <image-name> \
  bash -c "cd /code && <command>"
```

No image rebuild needed unless Dockerfile or dependencies changed.

## Cleanup

Always stop containers when done:

```bash
podman stop <container-name>
```
