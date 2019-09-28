Configuration tests
===================

Libpqxx comes with support for different build systems: the GNU autotools,
CMake, Visual Studio's "nmake", and raw GNU "make" on Windows.

For several of these build systems, we need to test things like "does this
compiler environment support `std::to_chars` for floating-point types?"

We test these things by trying to compile a particular snippet of code, and
seeing whether that succeeds.

To avoid duplicating those snippets for multiple build systems, we put them
here.  Both the autotools configuration and the CMake configuration can refer to
them that way.
