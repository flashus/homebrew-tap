class Detrix < Formula
  desc "Dynamic observability daemon — add metrics to any running line of code"
  homepage "https://github.com/flashus/detrix"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-aarch64-apple-darwin.tar.xz"
      sha256 "107e692ff039dac042a6349b43b002d2b3a5f30dde4527f1b45648d445e4091e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-x86_64-apple-darwin.tar.xz"
      sha256 "1f44db89ba2dc18e0a7d0a598817acaf2861d014fb33a3789a327f261de3d3b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ab3d142f133a71cb20d43598987678b201b13d965cb034eefd610c5aebc8602"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdf690789aad01a4a4c4282ac78075d70691f69f54292a26330b95d4b91d36eb"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "detrix" if OS.mac? && Hardware::CPU.arm?
    bin.install "detrix" if OS.mac? && Hardware::CPU.intel?
    bin.install "detrix" if OS.linux? && Hardware::CPU.arm?
    bin.install "detrix" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
