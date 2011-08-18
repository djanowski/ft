require "cutest"
require "./lib/ft"

setup do
  FusionTables::Connection.new
end

test "SELECT from public tables" do |conn|
  result = conn.query("SELECT Name FROM 1310767")

  assert_equal result[0][0], "Name"
end

test "raises errors" do |conn|
  assert_raise FusionTables::Error do
    conn.query("SELECT foo FROM 1310767")
  end
end
