require "sqlite3"
require "zlib"

# Open a database
db = SQLite3::Database.new "invoices_best_compress_new.db"

# Create a database
rows = db.execute <<-SQL
  create table if not exists invoices (
    id integer primary key autoincrement not null,
    invoiceid varchar(30) unique not null,
    content blob not null
  );
  create index if not exists invoice_index on invoices (invoiceid);
SQL

start = Time.now
input_files = Dir.glob('input_files/*')
input_file_count = input_files.length
input_files.each_with_index do |file, index|
  puts "Adding file #{index + 1} of #{input_file_count}"
  invoiceid = File.basename(file, '.xml')
  data = File.read(file)
  compressed = Zlib::Deflate.deflate(data, Zlib::BEST_COMPRESSION)
  db.execute("insert into invoices values (?, ?, ?);", [nil, invoiceid, compressed])
end
span = Time.now - start
puts "Time spent adding #{input_file_count}: #{Time.at(span).gmtime.strftime('%M minutes, %S seconds, %L milliseconds')}"
