require 'optparse'
require 'zip/zipfilesystem'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options] <input files>"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-oMANDATORY", "--output=FILE", "Write archive to FILE") do |file|
    options[:output] = file
  end
end.parse!

if options[:output].nil? or options[:output].empty?
  options[:output] = 'filesystem.zip'
end

if not options[:output] =~ /\.zip$/
  options[:output] += '.zip'
end

inputs = []
ARGV.each do |pattern|
  Dir.glob(pattern) do |file|
    inputs << File.expand_path(file)
  end
end

if inputs.length == 0
  puts "No input files given..."
  exit
end

compress_spans = []

for i in 1..5
  start_time = Time.now
  
  File.delete(options[:output]) if File.exists?(options[:output])
  
  Zip::ZipFile.open(options[:output], Zip::ZipFile::CREATE) do |zf|
    zf.dir.mkdir('input_files')
      inputs.each do |input|
      entry = File.join('input_files', File.basename(input))
      zf.add(entry, input)
    end
  end
  
  span = Time.now - start_time
  puts "Time spent compressing #{inputs.length} input files: #{Time.at(span).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
  compress_spans << span
end
  
zip_file = File.expand_path(options[:output])

pwd = Dir.pwd
begin
  Dir.mkdir(File.join(pwd, 'tmp'))
  Dir.mkdir(File.join(pwd, 'tmp', 'input_files'))
rescue
ensure
  Dir.chdir(File.join(pwd, 'tmp', 'input_files'))
end

start_time = Time.now
num_decompress = 0
one_file_spans = []

Zip::ZipFile.open(zip_file) do |zf|
  num_entries = zf.dir.entries('input_files').length
  num_decompress = 3 if num_entries < 10
  num_decompress = num_entries / 10 if num_entries > 10
  for i in 1..num_decompress
    one_file_start = Time.now
    file_name = zf.dir.entries('input_files')[i]
    zf.extract(File.join('input_files', file_name), File.join(Dir.pwd, file_name))
    one_file_span = Time.now - one_file_start
    one_file_spans << one_file_span
  end
end

span = Time.now - start_time
puts "Time spent decompressing #{num_decompress} files: #{Time.at(span).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
Dir.chdir(pwd)
Dir.glob(File.join(pwd, 'tmp', 'input_files', '*')) {|file| File.delete(file)}
Dir.rmdir(File.join(pwd, 'tmp', 'input_files'))
Dir.rmdir(File.join(pwd, 'tmp'))
puts "Minimum time spent decompressing one file: #{Time.at(one_file_spans.min).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
puts "Maximum time spent decompressing one file: #{Time.at(one_file_spans.max).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
total = one_file_spans.inject(:+)
len = one_file_spans.length
average = total.to_f / len # to_f so we don't get an integer result
sorted = one_file_spans.sort
median = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
puts "Average time spent decompressing one file: #{Time.at(average).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
puts "Median time spent decompressing one file: #{Time.at(median).gmtime.strftime('%H hours, %M minutes, %S seconds, %L milliseconds')}"
