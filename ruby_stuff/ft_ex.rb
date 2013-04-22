require 'prawn'
require 'prawn/security'
require 'prawn/layout'

require 'enumerator'

module Foo
  module Bar
	  class Example < Prawn::Document
	    def generate_document
	      line_cursor = y
	      text("Hello", :align => :left)
	      @y = line_cursor
	      text("Hello", :align => :center)
	      @y = line_cursor
	      text("Hello", :align => :right)
	      
		formatted_text [  { :text => "Some bold. ", :styles => [:bold] },
		                  { :text => "Some italic. ", :styles => [:italic] },
		                  { :text => "Bold italic. ", :styles => [:bold, :italic] },
		                  { :text => "Bigger Text. ", :size => 20 },
		                  { :text => "More spacing. ", :character_spacing => 3 },
		                  { :text => "Different Font. ", :font => "Courier" },
		                  { :text => "Some coloring. ", :color => "FF00FF" },
		                  { :text => "Link to the wiki. ", :color => "0000FF", :link => "https://github.com/prawnpdf/prawn/wiki" },
		                  { :text => "Link to the Text Reference. " , :color => "0000FF", :anchor => "Text Reference" }
		                ]
	    end
	    
	    def get_class_name
	      self.class
	    end
	  end
  end
end

module Foo
  def do_it
    filename = File.basename(__FILE__).gsub('.rb', '.pdf')
    doc = Foo::Bar::Example.new
    doc.generate_document
    doc.render_file filename
  end
  module_function :do_it
end

Foo.do_it