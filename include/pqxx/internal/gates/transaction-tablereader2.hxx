#include <pqxx/internal/callgate.hxx>

namespace pqxx
{
namespace internal
{
namespace gate
{
class PQXX_PRIVATE transaction_tablereader2 : callgate<transaction_base>
{
  friend class pqxx::tablereader2;

  transaction_tablereader2(reference x) : super(x) {}

  void BeginCopyRead(const std::string &table, const std::string &columns)
	{ home().BeginCopyRead(table, columns); }

  bool read_copy_line(std::string &line)
	{ return home().read_copy_line(line); }

  internal::encoding_group current_encoding()
	{ return home().current_encoding(); }
};
} // namespace pqxx::internal::gate
} // namespace pqxx::internal
} // namespace pqxx
