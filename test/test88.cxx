#include <iostream>

#include "test_helpers.hxx"

using namespace std;
using namespace pqxx;


// Test program for libpqxx.  Attempt to perform nested transactions.
namespace
{
void test_088()
{
  connection conn;
  
  work tx0{conn};
  test::create_pqxxevents(tx0);

  // Trivial test: create subtransactions, and commit/abort
  cout << tx0.exec1("SELECT 'tx0 starts'")[0].c_str() << endl;

  subtransaction T0a(static_cast<dbtransaction &>(tx0), "T0a");
  T0a.commit();

  subtransaction T0b(static_cast<dbtransaction &>(tx0), "T0b");
  T0b.abort();
  cout << tx0.exec1("SELECT 'tx0 ends'")[0].c_str() << endl;
  tx0.commit();

  // Basic functionality: perform query in subtransaction; abort, continue
  work tx1{conn, "tx1"};
  cout << tx1.exec1("SELECT 'tx1 starts'")[0].c_str() << endl;
  subtransaction tx1a{tx1, "tx1a"};
    cout << tx1a.exec1("SELECT '  a'")[0].c_str() << endl;
    tx1a.commit();
  subtransaction tx1b{tx1, "tx1b"};
    cout << tx1b.exec1("SELECT '  b'")[0].c_str() << endl;
    tx1b.abort();
  subtransaction tx1c{tx1, "tx1c"};
    cout << tx1c.exec1("SELECT '  c'")[0].c_str() << endl;
    tx1c.commit();
  cout << tx1.exec1("SELECT 'tx1 ends'")[0].c_str() << endl;
  tx1.commit();

  // Commit/rollback functionality
  work tx2{conn, "tx2"};
  const string Table = "test088";
  tx2.exec0("CREATE TEMP TABLE " + Table + "(no INTEGER, text VARCHAR)");

  tx2.exec0("INSERT INTO " + Table + " VALUES(1,'tx2')");

  subtransaction tx2a{tx2, "tx2a"};
    tx2a.exec0("INSERT INTO "+Table+" VALUES(2,'tx2a')");
    tx2a.commit();
  subtransaction tx2b{tx2, "tx2b"};
    tx2b.exec0("INSERT INTO "+Table+" VALUES(3,'tx2b')");
    tx2b.abort();
  subtransaction tx2c{tx2, "tx2c"};
    tx2c.exec0("INSERT INTO "+Table+" VALUES(4,'tx2c')");
    tx2c.commit();
  const result R = tx2.exec("SELECT * FROM " + Table + " ORDER BY no");
  for (const auto &i: R)
    cout << '\t' << i[0].c_str() << '\t' << i[1].c_str() << endl;

  PQXX_CHECK_EQUAL(R.size(), 3u, "Wrong number of results.");

  int expected[3] = { 1, 2, 4 };
  for (result::size_type n=0; n<R.size(); ++n)
    PQXX_CHECK_EQUAL(
	R[n][0].as<int>(),
	expected[n],
	"Hit unexpected row number.");

  tx2.abort();

  // Auto-abort should only roll back the subtransaction.
  work tx3{conn, "tx3"};
  subtransaction tx3a(tx3, "tx3a");
  PQXX_CHECK_THROWS(
	tx3a.exec("SELECT * FROM nonexistent_table WHERE nonattribute=0"),
	sql_error,
	"Bogus query did not fail.");

  // Subtransaction can only be aborted now, because there was an error.
  tx3a.abort();
  // We're back in our top-level transaction.  This did not abort.
  tx3.exec1("SELECT count(*) FROM pqxxevents");
  // Make sure we can commit exactly one more level of transaction.
  tx3.commit();
}
} // namespace


PQXX_REGISTER_TEST(test_088);
