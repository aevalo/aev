class Hola::Translator
  def initialize(language)
    if language.class.eql?(Symbol)
      @language = language
    elsif language.class.eql?(String)
      @language = language.downcase.to_sym
    else
      @language = :english
    end
  end

  def hi
    case @language
    when :spanish
      return "hola mundo"
    else
      return "hello world"
    end
  end
end
