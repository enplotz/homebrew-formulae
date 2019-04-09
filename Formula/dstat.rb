class Dstat < Formula
  desc "Versatile resource statistics tool"
  homepage "http://dag.wieers.com/home-made/dstat/"
  url "https://github.com/dagwieers/dstat/archive/0.7.3.tar.gz"
  sha256 "46e63821857b69fbc60cb2c7d893ccdd6f31cd9ef24b8bb0b68951e1c7374898"

  # commented until support for Python 3 is added (https://github.com/dagwieers/dstat/issues/163)
  # depends_on "python"

  # dstat does not work on macOS
  depends_on :linux

  def install
    # fix plugin resolving (gh-140)
    inreplace "dstat", "os.path.abspath(os.path.dirname(sys.argv[0]))", "os.path.abspath(os.path.dirname(os.path.realpath(sys.argv[0])))"
    # do "make install" ourselves
    bin.install "dstat"
    pkgshare.install_symlink bin/"dstat" => "dstat.py"
    dstat_plugins = (bin + "plugins")
    dstat_plugins.mkdir 0755
    dstat_plugins.install Dir["plugins/dstat_*.py"]
    man1.install "docs/dstat.1"
  end

  def caveats
    <<~EOS
      - Install additional plugins to 
        #{HOMEBREW_PREFIX}/bin/plugins/

      - Some plugins depend on /proc or 
        other paths being accessible
    EOS
  end

  test do
    assert_match "Dstat " + version.to_s, shell_output("#{bin}/dstat --version 2>&1")
    # this will test an external plugin, located in the plugins directory we set up above
    assert_match "---test--", shell_output("#{bin}/dstat --test 1 1 2>&1")
  end
end
