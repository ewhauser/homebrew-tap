class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.5.1/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "f183f46ac9c05de66c1dcd75725997c906e7865a6b6b12f953a14e32bd17dee7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.5.1/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "95f03471f382cf4bdf5802d641bd6a03ee97fbec468fa79a2eec12aeb110829b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.5.1/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bb5dc7df89e000805bcaedc8bdc92856e5ae9cfe54200242599ee6b9c4d1c4ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.5.1/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7838dc9acac8d302b3616081289069bb16a7dcdd9e98674061d411defc85ef1"
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
