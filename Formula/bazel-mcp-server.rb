class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.4.0/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "ac387d39ed1acacbc250cdeec9410622f51c11c2aaf042fc7d1b177cc0d3787b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.4.0/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "99054454c6c7ba4949ee7e5e20943f3ae65cdd67c8b0939be9214486a35420d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.4.0/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0885251955b328e29b91bba09ca2c2a23e878355306787a52399590fbd99305"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.4.0/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cf5291e4345c4a70f07d83cef364d95ed1aacde7ca764238177f7e440960ac13"
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
