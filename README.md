# plavipas/homebrew-tap

Homebrew tap of plavipas.

```sh
brew tap plavipas/tap
```

| Tool | What it is | Install |
|---|---|---|
| gitreason | Keeps the reasoning of coding agents next to the commits | `brew install plavipas/tap/gitreason` |
| portero | Default-browser router for macOS | `brew install --cask plavipas/tap/portero` |

Portero is ad-hoc signed, not notarized. After the install open it once (`open -a Portero`) and allow it in
System Settings > Privacy & Security > Open Anyway. See the [Portero README](https://github.com/plavipas/portero).

The gitreason cask is written by goreleaser from each release. The portero cask is rendered from the release by
`scripts/update-cask.sh` in the Portero repository.
