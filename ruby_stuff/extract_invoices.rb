require 'fileutils'
require 'keyval'
require 'tokyocabinet'
include TokyoCabinet

class DbError < StandardError; end

FileUtils.mkdir_p('temp/tcdb')
FileUtils.mkdir_p('temp/kvdb')

puts "TokyoCabinet:"
file_count = 0
dbfile = 'tokyo_cabinets/90.tcdb'
start_time = Time.now
begin
  db = HDB.new
  db.open(dbfile, HDB::OREADER)
  if db.ecode != 0
    raise DbError.new("Opening #{dbfile}: " + db.errmsg(db.ecode) + "\n")
  end
  keys = db.keys
  file_count = keys.length
  keys.each do |key|
    value = db.get(key)
    filename = File.join('temp', 'tcdb', key + '.xml')
    File.write(filename, value)
  end
  db.close
  db = nil
rescue DbError => pe
  STDERR.print("Reading #{dbfile}: " + pe.to_s + "\n")
ensure
  db.close unless db.nil?
end
end_time = Time.now
puts "Time used extracting #{file_count} invoices: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}\n"


puts "KeyVal Storage:"
start_time = Time.now
kv = KeyVal::KeyVal.new('tokyo_cabinets/90.kvdb')
kv.select_store('invoices')

keys = kv.keys
file_count = keys.length
keys.each do |key|
  data = kv.get_key(key)
  filename = File.join('temp', 'kvdb', "#{key}.xml")
  File.write(filename, data)
end

kv.close
end_time = Time.now
puts "Time used extracting #{file_count} invoices: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}\n"

FileUtils.remove_dir('temp')
