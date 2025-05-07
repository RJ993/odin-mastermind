require 'rainbow'

class Player
  def colorize(array, input)
  array.push(Rainbow('red').color(:red)) if input == 1 || input == 'red'
  array.push(Rainbow('orange').color(:orange)) if input == 2 || input == 'orange'
  array.push(Rainbow('yellow').color(:yellow)) if input == 3 || input == 'yellow'
  array.push(Rainbow('blue').color(:navyblue)) if input == 4 || input == 'blue'
  array.push(Rainbow('green').color(:darkgreen)) if input == 5 || input == 'green'
  array.push(Rainbow('purple').color(:purple)) if input == 6 || input == 'purple'
  end
end

class HumanPlayer < Player
  attr_reader :name
  attr_accessor :winner, :role
  def initialize(name, status = false, role = 'code_keeper')
    @name = name
    @winner = status
    @role = role
    if name == ''
      @name = 'Major Zero'
    end
  end
  def human_input(array)
    rejected_input = ['|', ' ', '+', '-', '\\', '/', ',', '.']
    5.times do
      guess = ''
      until rejected_input.any? { |char| guess.include?(char) } == false && guess != ''
      guess = gets.chomp.downcase
      end
      colorize(array, guess)
    end
  end
  def make_combination(code_array)
    puts "What will be the code? Put the colors in ONE line at a time"
    puts "The available colors are " + Rainbow('red, ').color(:red) + Rainbow('orange, ').color(:orange) + Rainbow('yellow, ').color(:yellow) + Rainbow('blue, ').color(:navyblue) + Rainbow('green, ').color(:darkgreen) + "and " + Rainbow('purple.').color(:purple)
      human_input(code_array)
    puts "Correct Code: #{code_array[0]}, #{code_array[1]}, #{code_array[2]}, #{code_array[3]}, #{code_array[4]}"
  end
  def guesses(guess_array)
    puts "What do you think the code combination is? Put the colors in ONE line at a time"
      human_input(guess_array)
    puts "You guessed the code: #{guess_array[0]}, #{guess_array[1]}, #{guess_array[2]}, #{guess_array[3]}, #{guess_array[4]}"
  end
  def status_change
    self.winner = true
  end
  def role_change
    self.role = 'guesser'
  end
end

class ComputerPlayer < Player
  attr_accessor :winner, :role
  def initialize(name = 'CPU', status = false, role = 'code_keeper')
    @name = name
    @winner = status
    @role = role
  end
  def make_combination(code_array)
    5.times do
    random_number = rand(1..6)
    colorize(code_array, random_number)
    end
  end
  def status_change
    self.winner = true
  end
  def role_change
    self.role = 'guesser'
  end
end