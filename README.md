# Setup

- Download `bws` with `cargo install bws --locked`
- Edit `$HOME/.config/chezmoi/.toml`:

```toml
[data]
    accessToken = ... # BitWarden access token
    is_work_machine = true/false
```

- Run `chezmoi update`
