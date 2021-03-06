class Glfw3 < Formula
  homepage "http://www.glfw.org/"
  url "https://downloads.sourceforge.net/project/glfw/glfw/3.1/glfw-3.1.tar.bz2"
  sha1 "bf7e8a7f79cbbfa68978aea2341e7fc7c6eef985"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-versions"
    sha1 "520a04a4d4f7611c29da7c7635f9b379dcc3651e" => :yosemite
    sha1 "12b86a9f1b86f8e5f9afe4b80ff42d877eb7a06a" => :mavericks
    sha1 "7b55fda39d57ed1bf8258555ef3e263fae7c7bca" => :mountain_lion
  end

  depends_on "cmake" => :build

  option :universal
  option "static", "Build static library only (defaults to building dylib only)"
  option "build-examples", "Build examples"
  option "build-tests", "Build test programs"

  # make library name consistent
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    args = std_cmake_args + %W[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]
    args << "-DGLFW_BUILD_UNIVERSAL=TRUE" if build.universal?
    args << "-DBUILD_SHARED_LIBS=TRUE" unless build.include? "static"
    args << "-DGLFW_BUILD_EXAMPLES=TRUE" if build.include? "build-examples"
    args << "-DGLFW_BUILD_TESTS=TRUE" if build.include? "build-tests"
    args << "."

    system "cmake", *args
    system "make", "install"
    libexec.install Dir["tests/*"] if build.include? "build-tests"
  end
end

__END__
diff -u a/CMakeLists.txt b/CMakeLists.txt
index
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -357,12 +357,7 @@
 #--------------------------------------------------------------------
 # Choose library output name
 #--------------------------------------------------------------------
-if (BUILD_SHARED_LIBS AND UNIX)
-    # On Unix-like systems, shared libraries can use the soname system.
-    set(GLFW_LIB_NAME glfw)
-else()
-    set(GLFW_LIB_NAME glfw3)
-endif()
+set(GLFW_LIB_NAME glfw3)
 
 #--------------------------------------------------------------------
 # Add subdirectories
