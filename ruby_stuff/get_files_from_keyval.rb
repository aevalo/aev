require 'keyval'
require 'fileutils'

def span_str(span)
  return '' if span.nil?
  return Time.at(span).gmtime.strftime('%Mmin, %Ss, %Lms')
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

kv = KeyVal::KeyVal.new('invoices.db')
kv.select_store('invoices')

temp_path = File.join(Dir.pwd, 'temp', 'input_files')
FileUtils.mkdir_p(temp_path)

spans = []
puts "Started reading at #{Time.now}"
10.step(10000, 10).each do |index|
  start_time = Time.now
  keyname = "invoice#{index}"
  data = kv.get_key(keyname)
  File.write(File.join(temp_path, "#{keyname}.xml"), data)
  spans << Time.now - start_time
end
puts "Completed reading at #{Time.now}"

FileUtils.remove_dir(File.join(Dir.pwd, 'temp'))

kv.close

print_spans(spans)
puts "\n"
