class ShuckCli < Formula
  desc "A fast shell script linter"
  homepage "https://github.com/ewhauser/shuck"
  version "0.0.30"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ewhauser/shuck/releases/download/v0.0.30/shuck-cli-aarch64-apple-darwin.tar.xz"
    sha256 "7ade57c1734ac76576ba74a77c9ef9892689c332afa3644d5f838882f6f66b0d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.30/shuck-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57fdca1b734d2b5ad15c72f84ecedf31d31f469a2b5ecb8bd97954672e35d31d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.30/shuck-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5aaf4c7903b83ba11dd65051a9f3cb66eea6b26a3182f1851dd35981a04a0574"
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
