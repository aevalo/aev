module Foo
  class Bar < Object
    def initialize
      super
    end
    
    def greet
      puts "Hello, World!!!"
    end
  end
  
  def get_class
    klass = 'Bar'
    return const_get(klass)
  end
  module_function :get_class
end

begin
  klass = Foo.const_get('Bar')
  puts "Found class #{klass}."
  bar = klass.new
  bar.greet
  
  puts Foo.get_class
  
  fake = Foo.const_get('Fake')
rescue NameError => ne
  puts "Exception caught: #{ne.message}"
end

begin
  require 'Blah'
rescue LoadError => le
  puts "Exception caught: #{le.message}"
end

