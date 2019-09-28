#include <optional>

int main(int, char*[])
{
    std::optional<int> o{0};
    return *o;
}
