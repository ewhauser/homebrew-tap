class BazelMcpServer < Formula
  desc "A token-efficient MCP server for Bazel invocations"
  homepage "https://github.com/ewhauser/bazel-mcp"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.3.0/bazel-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "a60e3f73dcf361b78708d595f4c119463d0e3e8f1120dd3e38d98fb9089b9cf0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.3.0/bazel-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "88597e7420273511e21cb55e2922c0fbd9915f9e9ccb0d1e64b237aaceeb7441"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.3.0/bazel-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f464ebc01bb1f8dc4857b80acc5d72a69108fd427f1b765f28b8b483d512e54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ewhauser/bazel-mcp/releases/download/v0.3.0/bazel-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "25c0c27909d663908977f47ab4d44d8ce126ed1d447554a57127bebfce9372c5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
