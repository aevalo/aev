require "sqlite3"
require "zlib"
require 'zip/zipfilesystem'

def span_str(span)
  return '' if span.nil?
  return Time.at(span).gmtime.strftime('%Mm%Ss%Lms')
end

def print_spans(spans)
  return if spans.nil?
  min = spans.min
  max = spans.max
  total = spans.inject(:+)
  len = spans.length
  average = total.to_f / len # to_f so we don't get an integer result
  sorted = spans.sort
  median = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
  
  puts "Count: #{len}, Min: #{span_str(min)}, Max: #{span_str(max)}, Average: #{span_str(average)}, Median: #{span_str(median)}, Total: #{span_str(total)}" 
end

pwd = Dir.pwd
zip_file = File.expand_path('invoices.zip')
uncompressed_sqlite = File.expand_path('invoices_no_compress.db')
compressed_sqlite = File.expand_path('invoices_best_compress.db')
compressed_sqlite_new = File.expand_path('invoices_best_compress_new.db')

zip_temp = File.join(pwd, 'temp', 'zip_input_files')
uncompressed_temp = File.join(pwd, 'temp', 'uncompressed_input_files')
compressed_temp = File.join(pwd, 'temp', 'compressed_input_files')
compressed_new_temp = File.join(pwd, 'temp', 'compressed_new_input_files')

FileUtils.mkdir_p(zip_temp)

spans = []
puts "Zip processing started at #{Time.now}"
10.step(10000, 10).each do |index|
  start_time = Time.now
  Zip::ZipFile.open(zip_file) do |zf|
    file_name = "invoice#{index}.xml"
    zf.extract(File.join('input_files', file_name), File.join(zip_temp, file_name))
  end
  span = Time.now - start_time
  spans << span
end
puts "Zip processing ended at #{Time.now}"

FileUtils.remove_dir(zip_temp)

print_spans(spans)
puts "\n"

FileUtils.mkdir_p(uncompressed_temp)

spans = []
puts "Uncompressed sqlite3 processing started at #{Time.now}"
10.step(10000, 10).each do |index|
  start_time = Time.now
  db = SQLite3::Database.new uncompressed_sqlite
  ret = db.execute("select content from invoices where name = ?;", ["input_files/invoice#{index}.xml"])
  data = ret.first.first
  File.write(File.join(uncompressed_temp, "invoice#{index}.xml"), data)
  span = Time.now - start_time
  spans << span
end
puts "Uncompressed sqlite3 processing ended at #{Time.now}"

FileUtils.remove_dir(uncompressed_temp)

print_spans(spans)
puts "\n"

FileUtils.mkdir_p(compressed_temp)

spans = []
puts "Compressed sqlite3 processing started at #{Time.now}"
10.step(10000, 10).each do |index|
  start_time = Time.now
  db = SQLite3::Database.new compressed_sqlite
  ret = db.execute("select content from invoices where name = ?;", ["input_files/invoice#{index}.xml"])
  data = ret.first.first
  uncompressed = Zlib::Inflate.inflate(data)
  File.write(File.join(compressed_temp, "invoice#{index}.xml"), uncompressed)
  span = Time.now - start_time
  spans << span
end
puts "Compressed sqlite3 processing ended at #{Time.now}"

FileUtils.remove_dir(compressed_temp)

print_spans(spans)
puts "\n"

FileUtils.remove_dir(File.join(pwd, 'temp'))

FileUtils.mkdir_p(compressed_new_temp)

spans = []
puts "Compressed sqlite3 (new) processing started at #{Time.now}"
10.step(10000, 10).each do |index|
  start_time = Time.now
  db = SQLite3::Database.new compressed_sqlite_new
  ret = db.execute("select content from invoices where invoiceid = ?;", ["invoice#{index}"])
  data = ret.first.first
  uncompressed = Zlib::Inflate.inflate(data)
  File.write(File.join(compressed_new_temp, "invoice#{index}.xml"), uncompressed)
  span = Time.now - start_time
  spans << span
end
puts "Compressed sqlite3 processing ended at #{Time.now}"

#FileUtils.remove_dir(compressed_new_temp)

print_spans(spans)
puts "\n"

#FileUtils.remove_dir(File.join(pwd, 'temp'))
