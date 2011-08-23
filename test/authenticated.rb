require "cutest"
require "./lib/ft"
require "./test/private"

setup do
  [FusionTables::Connection.new, ENV["EMAIL"], ENV["PASSWORD"], ENV["PRIVATE_TABLE_ID"]]
end

test "authenticated SELECTs" do |conn, email, password, table_id|
  conn.authenticate(email, password)

  result = conn.query("SELECT Client, Invoice FROM #{table_id}")

  assert_equal result, [
    ["Client", "Invoice"],
    ["Madalyn Streich", "1"],
    ["Mr. Vincenza Bailey", "2"]
  ]

  assert conn.inspect !~ /token/
end
