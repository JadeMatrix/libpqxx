#include "test_helpers.hxx"

using namespace std;
using namespace pqxx;


// Test: nontransaction changes are committed immediately (tested here against
// an asyncconnection).
namespace
{
int BoringYear = 1977;


void test_066()
{
  asyncconnection conn;
  nontransaction tx1{conn};

  test::create_pqxxevents(tx1);

  const string Table = "pqxxevents";

  // Verify our start condition before beginning: there must not be a 1977
  // record already.
  result R( tx1.exec("SELECT * FROM " + Table + " "
	            "WHERE year=" + to_string(BoringYear)) );

  PQXX_CHECK_EQUAL(
	R.size(),
	0u,
	"Already have a row for " + to_string(BoringYear) + ", cannot test.");

  // (Not needed, but verify that clear() works on empty containers)
  R.clear();
  PQXX_CHECK(R.empty(), "Result is not empty after clear().");

  // OK.  Having laid that worry to rest, add a record for 1977.
  tx1.exec0(
	"INSERT INTO " + Table + " VALUES"
        "(" +
	to_string(BoringYear) + ","
	"'Yawn'"
	")");

  // Abort T1.  Since T1 is a nontransaction, which provides only the
  // transaction class interface without providing any form of transactional
  // integrity, this is not going to undo our work.
  tx1.abort();

  // Verify that our record was added, despite the Abort()
  nontransaction tx2(conn, "tx2");
  R = tx2.exec("SELECT * FROM " + Table + " "
	"WHERE year=" + to_string(BoringYear));
  PQXX_CHECK_EQUAL(
	R.size(),
	1u,
	"Wrong number of records for " + to_string(BoringYear) + ".");

  PQXX_CHECK(R.capacity() >= R.size(), "Result's capacity is too small.");

  R.clear();
  PQXX_CHECK(R.empty(), "result::clear() doesn't always work.");

  // Now remove our record again
  tx2.exec0(
	"DELETE FROM " + Table + " "
	"WHERE year=" + to_string(BoringYear));

  tx2.commit();

  // And again, verify results
  nontransaction tx3(conn, "tx3");

  R = tx3.exec("SELECT * FROM " + Table + " "
	      "WHERE year=" + to_string(BoringYear));
  PQXX_CHECK_EQUAL(
	R.size(),
	0u,
	"Deleted row still seems to be there.");
}


PQXX_REGISTER_TEST(test_066);
} // namespace
