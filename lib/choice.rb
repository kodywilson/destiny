

class Choice
  def initialize msg, choices
    @msg = msg
    @choices = choices
  end

  def prompt
    p = []
    p << @msg
    @choices.each do |key, description|
      p << "[#{key}] #{description}"
    end
    puts "#{p.join("\n")}\n"
    gets.chomp
  end

  def get_response
  end
end
