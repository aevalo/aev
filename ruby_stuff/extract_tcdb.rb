require 'fileutils'
require 'tokyocabinet'
include TokyoCabinet

class DbError < StandardError; end

FileUtils.mkdir_p('temp/tcdb')

file_count = 0
dbfile = 'tokyo_cabinets/90.tcdb'
start_time = Time.now
begin
  db = HDB.new
  db.open(dbfile, HDB::OREADER)
  if db.ecode != 0
    raise DbError.new("Opening #{dbfile}: " + db.errmsg(db.ecode) + "\n")
  end
  file_count = db.keys.length
  db.keys.each do |key|
    value = db.get(key)
    filename = File.join('temp', 'tcdb', key + '.xml')
    File.open(filename, 'w') { |f| f.write(value) }
  end
  db.close
  db = nil
rescue DbError => pe
  STDERR.print("Reading #{dbfile}: " + pe.to_s + "\n")
ensure
  db.close unless db.nil?
end
end_time = Time.now
puts "Time used extracting #{file_count} invoices: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}"

