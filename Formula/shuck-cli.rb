class ShuckCli < Formula
  desc "A fast shell script linter"
  homepage "https://github.com/ewhauser/shuck"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ewhauser/shuck/releases/download/v0.2.3/shuck-cli-aarch64-apple-darwin.tar.xz"
    sha256 "51e51dff5660e45c7872c9f0025e2ec74af75984ce99c83f883ec05d0fc3f528"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/shuck/releases/download/v0.2.3/shuck-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fe7274a8c819cb229660be2e946a8afdd61649eecf494e8b878d4f99580f817"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/shuck/releases/download/v0.2.3/shuck-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6a0e7e8ba21b4039cf6fcd7d463832480264b73125061e5ab60381c387d59e3"
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
