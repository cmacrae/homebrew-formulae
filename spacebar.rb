class Spacebar < Formula
  desc "A minimal status bar for macOS."
  homepage "https://github.com/cmacrae/spacebar"
  license "MIT"
  version "1.4.0"
  url "https://github.com/cmacrae/spacebar/releases/download/v#{version}/spacebar-v#{version}.tar.gz"
  sha256 "03749d681a9e9d087630eb9ed1cb08500ec038039a40f624e5ae4e242e68ccf2"
  head "https://github.com/cmacrae/spacebar.git"

  depends_on :macos => :high_sierra

  def install
    (var/"log/spacebar").mkpath
    man.mkpath

    if build.head?
      system "make", "install"
    end

    bin.install "#{buildpath}/bin/spacebar"
    (pkgshare/"examples").install "#{buildpath}/examples/spacebarrc"
    man1.install "#{buildpath}/doc/spacebar.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/spacebarrc ~/.spacebarrc
    Logs will be found in
      #{var}/log/spacebar/spacebar.[out|err].log
    EOS
  end

  service do
    run "#{opt_bin}/spacebar"
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    keep_alive true
    log_path  "#{var}/log/spacebar/spacebar.out.log"
    error_log_path "#{var}/log/spacebar/spacebar.err.log"
    run_at_load true
  end

  test do
    assert_match "spacebar-v#{version}", shell_output("#{bin}/spacebar --version")
  end
end
