require 'keyval'

inputs = []
Dir.glob('temp/tcdb/*.xml') do |file|
  inputs << File.expand_path(file)
end
dbfile = 'tokyo_cabinets/90.kvdb'

kv = KeyVal::KeyVal.new(dbfile)
kv.create_store('invoices')

input_count = inputs.length

start_time = Time.now
puts "Started at #{start_time}"
inputs.each_with_index do |input, index|
  puts "Processing input #{index + 1} of #{input_count}"
  key = File.basename(input, '.xml')
  value = File.read(input)
  kv.add_key(key, value, true, Zlib::BEST_COMPRESSION)
end
end_time = Time.now
puts "Completed at #{end_time}"

kv.close

puts "Time spent adding #{input_count} input files: #{Time.at(end_time - start_time).gmtime.strftime('%Mmin, %Ss, %Lms')}"
