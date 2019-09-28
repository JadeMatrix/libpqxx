#include <charconv>

int main(int, char*[])
{

    char z[100];
    using ld = long double;
    auto rt = std::to_chars(
        z, z + sizeof(z), ld{0.1},
        std::chars_format::generic);
    if (rt.ec != std::errc{}) return 1;
    ld n;
    auto rf = std::from_chars(z, z + sizeof(z), n);
    if (rf.ec != std::errc{}) return 2;
    return int(n);
}
