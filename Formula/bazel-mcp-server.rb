class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.1/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "45339280d3212884c5f6f7d7c235496fed293e45ba16cbc71e6ff069ea97298e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.1/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "e0e783fa465744767e90584dd40d77823b18795f394406e89b170fdcdc71f255"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.1/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "438df8821b8902877612b57894471bd8e59f3ab8e72ad37c4dc8802150868f59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.7.1/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3008a23eb80b4888d34398d61c0e303d09980d5adf9217265ef6fa6f54fc087c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bazel-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bazel-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bazel-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bazel-mcp"
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
