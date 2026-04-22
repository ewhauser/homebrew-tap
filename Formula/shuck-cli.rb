class ShuckCli < Formula
  desc "A fast shell script linter"
  homepage "https://github.com/ewhauser/shuck"
  version "0.0.17"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ewhauser/shuck/releases/download/v0.0.17/shuck-cli-aarch64-apple-darwin.tar.xz"
    sha256 "c53a5ec19ff0b7368e3d0de0aed6aaa98e242ca71ba48e78ec3ef6ccfe931cdd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.17/shuck-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7e4e3f9ff1d7a4bff1282530f4962a496df547274b09f3f29ea6e421d41089f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.17/shuck-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94847b89d6dbc8552feb503f555002b18c546b99153a6405f23e8fb5808f1933"
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
    bin.install "shuck" if OS.mac? && Hardware::CPU.arm?
    bin.install "shuck" if OS.linux? && Hardware::CPU.arm?
    bin.install "shuck" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
