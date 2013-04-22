require 'fileutils'
require 'kyotocabinet'
include KyotoCabinet

FileUtils.mkdir_p('temp/kch_def')
dbfile = 'tokyo_cabinets/90_def.kch#opts=c#zcomp=def'

file_count = 0

puts "KyotoCabinet (deflated):"
start_time = Time.now
begin
  # create the database object
  db = DB::new
  # open the database
  unless db.open(dbfile, DB::OREADER)
  #  STDERR.printf("open error: %s\n", db.error)
  end
  # traverse records
  cur = db.cursor
  cur.jump
  while rec = cur.get(true)
    filename = File.join('temp', 'kch_def', rec[0] + '.xml')
    File.write(filename, rec[1])
    file_count += 1
  end
  cur.disable
rescue Exception => pe
  STDERR.print("Reading #{dbfile}: " + pe.to_s + "\n")
ensure
  # close the database
  unless db.close
    STDERR.printf("close error: %s\n", db.error)
  end
  db = nil
end
end_time = Time.now
puts "Time used extracting #{file_count} invoices: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}\n"
