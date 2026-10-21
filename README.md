# Zcode

This repository is a fork of [Zed](https://github.com/zed-industries/zed). See [FORK.md](./FORK.md) for more information.

[![Zed](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/zed-industries/zed/main/assets/badge/v0.json)](https://zed.dev)
[![CI](https://github.com/zed-industries/zed/actions/workflows/run_tests.yml/badge.svg)](https://github.com/zed-industries/zed/actions/workflows/run_tests.yml)

---

### Configuration

User settings live under the Zcode config directory (not Zed's):

- macOS / Linux: `~/.config/zcode/` (or `$XDG_CONFIG_HOME/zcode/`)
- Windows: `%APPDATA%\Zcode\`

### Developing Zcode

- [Building for macOS](./docs/src/development/macos.md)
- [Building for Linux](./docs/src/development/linux.md)
- [Building for Windows](./docs/src/development/windows.md)

After building, the editor binary is `zcode` (for example `cargo run -p zed --bin zcode`).

### Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for upstream contribution guidelines.

### Licensing

Source code is licensed primarily under GPL-3.0-or-later, with Apache-2.0 components where marked (same as upstream Zed).

License information for third party dependencies must be correctly provided for CI to pass.

We use [`cargo-about`](https://github.com/EmbarkStudios/cargo-about) to automatically comply with open source licenses. If CI is failing, check the following:

- Is it showing a `no license specified` error for a crate you've created? If so, add `publish = false` under `[package]` in your crate's Cargo.toml.
- Is the error `failed to satisfy license requirements` for a dependency? If so, first determine what license the project has and whether this system is sufficient to comply with this license's requirements. If you're unsure, ask a lawyer. Once you've verified that this system is acceptable add the license's SPDX identifier to the `accepted` array in `script/licenses/zed-licenses.toml`.
- Is `cargo-about` unable to find the license for a dependency? If so, add a clarification field at the end of `script/licenses/zed-licenses.toml`, as specified in the [cargo-about book](https://embarkstudios.github.io/cargo-about/cli/generate/config.html#crate-configuration).
