class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.6.0/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "abdf6f3d41b16f99d9f18b03202c8173b7fcb369e8510267224be4cefd5f41f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.6.0/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "0692d7834fa1d94d494089b65fe451bd0b184ca83e4cb5ae539f8264684f5f7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.6.0/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da403aff5ce56003bc4127aa8f095dfb0edf939120fe546017a9ff6da2713502"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.6.0/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "117720fe41b1f1ba356bee06ad5cd84f9b0bef1e9cd1ecf80c46b10700394eee"
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
