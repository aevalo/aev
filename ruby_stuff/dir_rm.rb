pwd = Dir.pwd
Dir.glob(File.join(pwd, 'tmp', 'input_files', '*')) {|file| File.delete(file)}
Dir.rmdir(File.join(pwd, 'tmp', 'input_files'))
Dir.rmdir(File.join(pwd, 'tmp'))
