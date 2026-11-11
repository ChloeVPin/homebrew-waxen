class Waxen < Formula
  desc "Explain why macOS won't open an app, disk image, or installer"
  homepage "https://github.com/ChloeVPin/waxen"
  url "https://github.com/ChloeVPin/waxen/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c9106939672ae2038934e6db6d6461ccfa63c1030048b4cd43ab3d19fe02ae36"
  license "MIT"

  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/waxen"
    bash_completion.install "completions/waxen.bash" => "waxen"
    zsh_completion.install "completions/_waxen"
    fish_completion.install "completions/waxen.fish"
    man1.install "man/waxen.1"
  end

  def caveats
    <<~EOS
      Right-click apps in Finder: waxen finder install
      Remove the Quick Action: waxen finder uninstall
      Waxen builds from source; no notarized prebuilt binary is provided.
    EOS
  end

  test do
    assert_match "waxen #{version}", shell_output("#{bin}/waxen --version")
    report = JSON.parse(shell_output("#{bin}/waxen #{testpath}/Missing.app --json", 66))
    assert_equal "target_missing", report.fetch("inspectionStatus")
    assert_equal "inconclusive", report.fetch("launchStatus")
  end
end
