#include <experimental/optional>

int main(int, char*[])
{
    std::experimental::optional<int> o{0};
    return *o;
}
