class ShuckCli < Formula
  desc "A fast shell script linter"
  homepage "https://github.com/ewhauser/shuck"
  version "0.0.24"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ewhauser/shuck/releases/download/v0.0.24/shuck-cli-aarch64-apple-darwin.tar.xz"
    sha256 "579c732a28dac15637bbce89e72dfcf799356d0d1500294acdf318f34374b47b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.24/shuck-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06c464eff94e60d851b5e308e5f14d49e15a04f6b3611e80635004c55af3b70a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/shuck/releases/download/v0.0.24/shuck-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "845d7d34aa4fb5955385b2d9d3de1eb0661fbfa51e77e5229b3bec7a3f6f0559"
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
