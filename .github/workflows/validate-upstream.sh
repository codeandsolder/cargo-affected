#!/usr/bin/env bash
set -euo pipefail

# Invoked on the exact upstream candidate, with the fork's reviewed script
# read from its existing main commit (not from the incoming upstream tree).
# The shared workflow has already installed Rust and mandatory sccache.
cargo fmt --all -- --check
cargo clippy --locked --all-targets -- -D warnings

# cargo-affected functional tests run cargo-nextest recursively. Install the
# pinned upstream CI test runner with managed sccache rather than silently
# reducing validation to crate unit tests.
if ! cargo nextest --version 2>/dev/null | rg -q 'nextest 0\.9\.152\b'; then
    cargo install --locked cargo-nextest --version 0.9.152
fi
cargo test --locked --all-targets
