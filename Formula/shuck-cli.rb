class ShuckCli < Formula
  desc "A fast shell script linter"
  homepage "https://github.com/ewhauser/shuck"
  version "0.2.11"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ewhauser/shuck/releases/download/v0.2.11/shuck-cli-aarch64-apple-darwin.tar.xz"
    sha256 "089a2ace3bd8b414f615c2c9bfd217a0d2b5302a428e0fefa821e7188a43e5f7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/shuck/releases/download/v0.2.11/shuck-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d1ac87a617edc875932edc00fedfa7b995ad878a7e1b0ab14bf5403245d9e8d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/shuck/releases/download/v0.2.11/shuck-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cf0a7811bae7c33dad70c0affa4f766c413766782090c9d37197d853bc7c5da"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "shuck"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "shuck"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "shuck"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
