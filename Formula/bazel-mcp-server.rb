class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.0/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "01d487eb8a8cf04fe17175f4db8a701977ee5ad27a9f6ab77d335bed03db4c22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.0/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "dd0f002b359aff8997d482b1b5aec96c13f1cba0aefe54d6de819033bc49b5a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.0/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "44e36673a5d502f3ee314bdbe629380c148ff97478d23e2a1c5c3594dac9d386"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.0/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af2b79525f7c766f799fd57c9f6c44fb9313e92b52c5ff8b699353ab8dbb61ce"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
    bin.install "bazel-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "bazel-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "bazel-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "bazel-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
