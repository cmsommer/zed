# Zcode fork notes

This repository is a fork of [Zed](https://github.com/zed-industries/zed), rebranded as **Zcode**. Upstream already documents the primary rename points for forks; this file records what was changed here and what was left alone.

## How naming and config paths work

Runtime data, config, cache, and log locations are derived from a single constant:

```rust
// crates/paths/src/paths.rs
pub const APP_NAME: &str = "Zcode";
```

`APP_NAME_LOWERCASE` is computed from that value (`"zcode"`). It is used for XDG-style directories on Linux/FreeBSD and for macOS `~/.config/...`.

There is also a compile-time check in `crates/zed/src/main.rs` that **`APP_NAME_LOWERCASE` must match the Cargo binary name**. Renaming the app therefore requires renaming the `[[bin]]` (and `default-run`) in `crates/zed/Cargo.toml` as well.

## Resulting directories

| Purpose | macOS | Linux / FreeBSD | Windows |
| --- | --- | --- | --- |
| Config | `~/.config/zcode/` | `$XDG_CONFIG_HOME/zcode/` (default `~/.config/zcode/`) | `%APPDATA%\Zcode\` |
| Data | `~/Library/Application Support/Zcode/` | `$XDG_DATA_HOME/zcode/` | `%LOCALAPPDATA%\Zcode\` |
| Logs | `~/Library/Logs/Zcode/` | under the data dir | under the data dir |
| Cache | under system caches / `Zcode` | `$XDG_CACHE_HOME/zcode/` | under LocalAppData / `Zcode` |

Settings, keymaps, themes, and snippets live under the config directory (for example `~/.config/zcode/settings.json`).

These paths intentionally **do not collide** with an installed upstream Zed (`~/.config/zed`, etc.). Existing Zed settings are not migrated automatically; copy them if you want to reuse them.

## Changes applied in this fork

### Required for a working rename

- `crates/paths/src/paths.rs` — `APP_NAME = "Zcode"`
- `crates/zed/Cargo.toml` — binary / `default-run` renamed to `zcode`
- Display names and app IDs in `crates/release_channel` (`Zcode`, `dev.zcode.Zcode`, …)
- Bundle metadata in `crates/zed/Cargo.toml` (`[package.metadata.bundle-*]`)
- Windows product name / installer identity in `crates/windows_resources` and `script/bundle-windows.ps1`
- Linux packaging in `script/bundle-linux` and install/uninstall helpers
- CLI clap command name and macOS CLI install path (`/usr/local/bin/zcode`)
- User-visible menu / About strings

### Intentionally unchanged (for now)

- **Cargo package name** remains `zed` (`cargo run -p zed --bin zcode`). Renaming the crate graph is a much larger churn.
- **`zed://` URL scheme** remains the deep-link / custom URL protocol. Handlers and parsers still expect `zed://`; switching to `zcode://` would need coordinated parser and registration updates.
- **Project-local** `.zed/` folders (settings, tasks, debug) keep the upstream name so project configs stay compatible.
- **Upstream docs** under `docs/` still describe Zed paths in many places; treat [this file](./FORK.md) and the README as the fork-accurate source for config locations.
- Cloud services, telemetry endpoints, and legal pages still refer to Zed Industries / zed.dev unless separately forked.

## Developing

```sh
cargo run -p zed --bin zcode
# or, because default-run is zcode:
cargo run -p zed
```

On Linux, `./script/install-linux` builds a release bundle and installs a `zcode` symlink under `~/.local/bin`.

## Migrating settings from Zed

```sh
# Linux / macOS example
mkdir -p ~/.config/zcode
cp -a ~/.config/zed/. ~/.config/zcode/
```

Adjust paths for Windows (`%APPDATA%\Zed` → `%APPDATA%\Zcode`) and for data directories if you also want databases, extensions, or language servers copied over.
