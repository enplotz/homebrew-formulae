class AdoptopenjdkAT11 < Formula
  desc "AdoptOpenJDK Java Development Kit 11 (LTS) [HotSpot]"
  homepage "https://adoptopenjdk.net/"
  # tag "linuxbrew"

  version "11.0.2+9"
  if OS.mac?
    url "https://adoptopenjdk.net/"
  else
    url "https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.2%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.2_9.tar.gz"
    sha256 "d02089d834f7702ac1a9776d8d0d13ee174d0656cf036c6b68b9ffb71a6f610e"
  end

  depends_on :linux

  def install
    prefix.install Dir["*"]
    share.mkdir
  end

  test do
    (testpath/"Hello.java").write <<~EOS
      class Hello {
        public static void main(final String... args) {
          final var h = "Homebrew";
          System.out.println("Hello " + h);
        }
      }
    EOS
    system bin/"javac", "Hello.java"
    assert_predicate testpath/"Hello.class", :exist?, "Failed to compile Java program!"
    assert_equal "Hello Homebrew\n", shell_output("#{bin}/java Hello")
  end
end