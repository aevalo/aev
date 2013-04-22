require 'sqlite3'
require 'zlib'

module KeyVal
  class KeyVal < Object
    def initialize(dbfile, options = {})
      @db = SQLite3::Database.new(dbfile, options)
    end

    def store_exists?(store)
      return false if store.nil? or (store =~ /^\w+$/).nil?
      ret = @db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name=?;", store)
      return (not ret.empty? and ret.first.include?(store))
    end

    def create_store(store)
      return false if store.nil? or (store =~ /^\w+$/).nil?
      @db.execute("CREATE TABLE IF NOT EXISTS main.#{store} (id INTEGER PRIMARY KEY NOT NULL, key VARCHAR(255) NOT NULL, is_compressed INT(1) NOT NULL, value BLOB NOT NULL);")
      @db.execute("CREATE UNIQUE INDEX IF NOT EXISTS main.#{store}_index ON #{store} (key);")
      @store = store
      return true
    end

    def select_store(store)
      return false if not store_exists?(store)
      @store = store
      return true
    end

    def delete_store(store)
      return false if not store_exists?(store)
      @db.execute("DROP INDEX IF EXISTS main.#{store}_index;")
      @db.execute("DROP TABLE IF EXISTS main.#{store};")
      @store = nil
    end

    def close
      @db.close
      if @db.closed?
        @store = nil
        @db = nil
        return true
      end
      return false
    end

    def add_key(key, value, compress = false, compression_level = Zlib::DEFAULT_COMPRESSION)
      return if @store.nil? or key.nil? or value.nil?
      return false if key_exists?(key)
      is_compressed = (compress ? 1 : 0)
      data = ''
      if is_compressed == 1
        data = Zlib.deflate(value, compression_level)
      else
        data = value
      end
      @db.execute("INSERT INTO main.#{@store} VALUES(?, ?, ?, ?);", nil, key, is_compressed, data)
      return true
    end

    def update_key(key, value, compress = false, compression_level = Zlib::DEFAULT_COMPRESSION)
      return false if @store.nil? or key.nil? or value.nil?
      return false if not key_exists?(key)
      is_compressed = (compress ? 1 : 0)
      data = ''
      if is_compressed == 1
        data = Zlib.deflate(value, compression_level)
      else
        data = value
      end
      @db.execute("UPDATE main.#{@store} SET is_compressed=?, value=? WHERE key=?;", is_compressed, data, key)
      return true
    end

    def delete_key(key)
      return false if @store.nil? or key.nil?
      if key_exists?(key)
        @db.execute("DELETE FROM main.#{@store} WHERE key=?;", key)
        return true
      end
      return false
    end

    def get_key(key)
      return nil if @store.nil? or key.nil?
      if key_exists?(key)
        ret = @db.get_first_row("SELECT is_compressed, value FROM main.#{@store} WHERE key=?;", key)
        return nil if ret.nil? or ret.empty?
        if ret[0] == 1
          return Zlib.inflate(ret[1])
        else
          return ret[1]
        end
      end
      return nil
    end

    def key_exists?(key)
      return false if @store.nil? or key.nil?
      ret = @db.get_first_value("SELECT key FROM main.#{@store} WHERE key=?;", key)
      return true if not ret.nil? and ret.eql?(key)
      return false
    end
    
    def keys
      return [] if @store.nil?
      ret = @db.execute("SELECT key FROM main.#{@store};")
      return ret.flatten
    end

    def [](key)
      return get_key(key)
    end

    def []=(key, value)
      return update_key(key, value) if key_exists?(key)
      return add_key(key, value)
    end
  end
end