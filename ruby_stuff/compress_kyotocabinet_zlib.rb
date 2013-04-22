require 'kyotocabinet'
include KyotoCabinet

inputs = []
Dir.glob('temp/tcdb/*.xml') do |file|
  inputs << File.expand_path(file)
end
dbfile = 'tokyo_cabinets/90_zlib.kch#opts=c#zcomp=zlib'

input_count = inputs.length

# create the database object
db = DB::new(DB::GCONCURRENT)

# open the database
unless db.open(dbfile, DB::OWRITER | DB::OCREATE | DB::OAUTOTRAN)
  STDERR.printf("open error: %s\n", db.error)
end

start_time = Time.now
puts "Started with zlib compression at #{start_time}"
inputs.each_with_index do |input, index|
  # store records
  key = File.basename(input, '.xml')
  value = File.read(input)
  unless db.set(key, value)
    STDERR.printf("set error: %s\n", db.error)
  end
end
end_time = Time.now
puts "Completed at #{end_time}"

# close the database
unless db.close
  STDERR.printf("close error: %s\n", db.error)
end

puts "Time spent adding #{input_count} input files: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}\n"
