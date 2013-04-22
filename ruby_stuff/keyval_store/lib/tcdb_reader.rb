require 'tokyocabinet'
require 'fileutils'
include TokyoCabinet

module KeyVal
  class DbError < StandardError; end
  
  def extract_tcdb_file(dbfile)
    begin
      db = HDB.new
      db.open(dbfile, HDB::OREADER)
      if db.ecode != 0
        raise DbError.new("Opening #{dbfile}: " + db.errmsg(db.ecode) + "\n")
      end
      db.keys.each do |key|
        value = db.get(key)
        filename = File.join(key[-2,2], key[-4,2], key + '.xml')
        FileUtils.mkdir_p(File.join(key[-2,2], key[-4,2]))
        File.open(filename, 'w') { |f| f.write(value) }
      end
      db.close
      db = nil
    rescue DbError => pe
      STDERR.print("Reading #{dbfile}: " + pe.to_s + "\n")
    ensure
      db.close unless db.nil?
    end
  end
  module_function :extract_tcdb_file
end
