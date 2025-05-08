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
   acceptable_input = ['red', 'yellow', 'orange', 'blue', 'green', 'purple']
    6.times do
      guess = ''
      until acceptable_input.any? { |color| guess.include?(color) } == true
      puts 'Invalid input, Try again!' if acceptable_input.any? { |color| guess.include?(color) } == false && guess != ''
      guess = gets.chomp.downcase
      end
      colorize(array, guess)
    end
  end
  def make_combination(code_array)
    puts "What will be the code? Put the colors in ONE line at a time"
    puts "The available colors are " + Rainbow('red, ').color(:red) + Rainbow('orange, ').color(:orange) + Rainbow('yellow, ').color(:yellow) + Rainbow('blue, ').color(:navyblue) + Rainbow('green, ').color(:darkgreen) + "and " + Rainbow('purple.').color(:purple)
      human_input(code_array)
    puts "Correct Code: #{code_array[0]}, #{code_array[1]}, #{code_array[2]}, #{code_array[3]}, #{code_array[4]}, #{code_array[5]}"
  end
  def guesses(guess_array)
    puts "What do you think the code combination is? Put the colors in ONE line at a time"
      human_input(guess_array)
    puts "You guessed the code: #{guess_array[0]}, #{guess_array[1]}, #{guess_array[2]}, #{guess_array[3]}, #{guess_array[4]}, #{guess_array[5]}"
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
  def insert_combination(array)
    6.times do
    random_number = rand(1..6)
    colorize(array, random_number)
    end
  end
  def guesses(guess_array, old_guess, code_array)
    insert_combination(guess_array)
    check_for_color(guess_array, old_guess, code_array)
    correct_place?(guess_array, old_guess, code_array)
    puts "CPU guessed the code: #{guess_array[0]}, #{guess_array[1]}, #{guess_array[2]}, #{guess_array[3]}, #{guess_array[4]}, #{guess_array[5]}"
  end
  def status_change
    self.winner = true
  end
  def role_change
    self.role = 'guesser'
  end
  def correct_place?(guess_array, old_guess, code_array)
    old_guess.each_with_index do |color_A, index_A|
      code_array.each_with_index do |color_B, index_B|
        if color_A == color_B && index_A == index_B
          guess_array.delete_at(index_A)
          guess_array.insert(index_A, color_A)
        end
      end
    end
  end
  def check_for_color(guess_array, old_guess, code_array)
    old_guess.uniq.each do |color_A|
        if code_array.include?(color_A) == true
            place = rand(0..5)
            guess_array.delete_at(place)
            guess_array.insert(place, color_A)
        end
    end
  end
end