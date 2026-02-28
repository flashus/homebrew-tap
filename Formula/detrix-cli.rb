class DetrixCli < Formula
  desc "Dynamic observability daemon — add metrics to any running line of code"
  homepage "https://github.com/flashus/detrix"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9afd0da4f978e678757352429231d78e8bef6638a3e39c2be41bb64c6b680102"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ab5aabd931a82c215113915f62e7ba8ecfc0f8a7620a09e1214e07495c95d3cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "87e3a3341d2f0853608ce284278c4cd750e0e6780b16ad0c84c802b76394f816"
    end
    if Hardware::CPU.intel?
      url "https://github.com/flashus/detrix/releases/download/v1.1.0/detrix-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89b542b0efad823c84ce501bad8dd910a3f3be89cfc70c43f9f9707e2d1896a0"
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
