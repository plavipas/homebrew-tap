cask "portero" do
  version "0.1.1"
  sha256 "a1a218bf0dcdf55e5bf6b4c102d6e1ae3f421032a76fa268c8ec2987f7272eab"

  url "https://github.com/plavipas/portero/releases/download/v#{version}/Portero_#{version}_darwin_universal.zip"
  name "Portero"
  desc "Default-browser router"
  homepage "https://github.com/plavipas/portero"

  depends_on macos: :ventura

  app "Portero.app"
  command_wrapper "portero", content: <<~SH
    #!/bin/sh
    # Installed as the "portero" command by the Homebrew cask (command_wrapper). It is pasted into a Ruby heredoc:
    # keep it free of backslashes and of the Ruby interpolation marker except for the appdir below.
    APP="#{appdir}/Portero.app"
    BIN="$APP/Contents/MacOS/portero"
    if [ ! -x "$BIN" ]; then
      echo "Portero.app not found at $APP; run: brew reinstall --cask portero" >&2
      exit 1
    fi
    # A quarantined, not yet approved app makes Gatekeeper hang the first launch; print a hint instead.
    FLAGS=$(/usr/bin/xattr -p com.apple.quarantine "$APP" 2>/dev/null) || exec "$BIN" "$@"
    FLAGS=${FLAGS%%;*}
    case "$FLAGS" in
      "" | *[!0-9a-fA-F]*) exec "$BIN" "$@" ;;
    esac
    # Bit 0x40 is set by macOS once the user approved the app.
    if [ $((0x$FLAGS & 64)) -ne 0 ]; then
      exec "$BIN" "$@"
    fi
    echo "portero: $APP is quarantined and not approved yet, so macOS would block it." >&2
    echo "  Approve it: open -a Portero, then System Settings > Privacy & Security > Open Anyway." >&2
    echo "  Or run: xattr -dr com.apple.quarantine '$APP'" >&2
    exit 3
  SH

  preflight_steps do
    if_path_exists "Applications/Portero.app", base: :home do
      run "/bin/sh", args: [
        "-c",
        "echo 'portero: ~/Applications/Portero.app (make install) is installed; " \
        "remove it first: rm -rf ~/Applications/Portero.app, then brew install again. " \
        "One install method per Mac.' >&2; exit 1",
      ]
    end
  end

  caveats <<~EOS
    Portero is ad-hoc signed, not notarized. Approve it first, before anything else:
      open -a Portero
    If macOS blocks it, allow it in System Settings > Privacy & Security > Open Anyway
    (or run: xattr -dr com.apple.quarantine /Applications/Portero.app).
    Only then create the rules and make Portero the default browser:
      portero rules init
      portero default set
    Until approved, `portero` prints this hint and exits 3.
  EOS
end
