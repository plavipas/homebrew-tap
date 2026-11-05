cask "portero" do
  version "0.1.0"
  sha256 "0e5adc15dfee90efdac8f45ea254d24426ecc118cc3d541cfd496f8408142682"

  url "https://github.com/plavipas/portero/releases/download/v#{version}/Portero_#{version}_darwin_universal.zip"
  name "Portero"
  desc "Default-browser router for macOS"
  homepage "https://github.com/plavipas/portero"

  depends_on macos: ">= :ventura"

  app "Portero.app"
  binary "#{appdir}/Portero.app/Contents/MacOS/portero"

  caveats <<~EOS
    Portero is ad-hoc signed, not notarized. Open it once so macOS lets it run:
      open -a Portero
    If macOS blocks it, allow it in System Settings > Privacy & Security > Open Anyway
    (or run: xattr -dr com.apple.quarantine /Applications/Portero.app).
    Then create the rules and make Portero the default browser:
      portero rules init
      portero default set
  EOS
end
