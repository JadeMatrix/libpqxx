#include <charconv>

int main(int, char*[])
{
    char z[100];
    using ull = unsigned long long;
    auto rt = std::to_chars(z, z + sizeof(z), ull{0});
    if (rt.ec != std::errc{}) return 1;
    ull n;
    auto rf = std::from_chars(z, z + sizeof(z), n);
    if (rf.ec != std::errc{}) return 2;
    return int(n);
}
