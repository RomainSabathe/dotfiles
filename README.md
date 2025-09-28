# Setup

- Download `bws` with `cargo install --git https://github.com/bitwarden/sdk-sm bws --locked`
- Edit `$HOME/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    accessToken = ... # BitWarden access token
    is_work_machine = true/false
```

- Run `chezmoi update`
