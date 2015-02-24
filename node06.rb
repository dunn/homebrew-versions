class Node06 < Formula
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.6.21/node-v0.6.21.tar.gz"
  sha1 "31f564bf34c64b07cae3b9a88a87b4a08bab4dc5"
  revision 1

  option "with-debug", "Build with debugger hooks"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "openssl"

  fails_with :llvm do
    build 2326
  end

  env :std

  def install
    inreplace "wscript" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! "/opt/local/lib", "/usr/lib"
    end

    args = ["--prefix=#{prefix}", "--without-npm"]
    args << "--debug" if build.with? "debug"
    args << "--openssl-includes=#{Formula["openssl"].include}"
    args << "--openssl-libpath=#{Formula["openssl"].lib}"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      Homebrew has NOT installed npm.

      After installing, add the following path to your NODE_PATH environment
      variable to have npm libraries picked up:
        #{HOMEBREW_PREFIX}/lib/node_modules
    EOS
  end
end
