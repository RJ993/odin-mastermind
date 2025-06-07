require 'rainbow'

class Player
  def colorize(array, input)
    array.push(Rainbow('red').color(:red)) if [1, 'red'].include?(input)
    array.push(Rainbow('orange').color(:orange)) if [2, 'orange'].include?(input)
    array.push(Rainbow('yellow').color(:yellow)) if [3, 'yellow'].include?(input)
    array.push(Rainbow('blue').color(:navyblue)) if [4, 'blue'].include?(input)
    array.push(Rainbow('green').color(:darkgreen)) if [5, 'green'].include?(input)
    array.push(Rainbow('purple').color(:purple)) if [6, 'purple'].include?(input)
  end
end

class HumanPlayer < Player
  attr_accessor :name, :winner, :role

  def initialize(name, status = false, role = 'code_keeper') # rubocop:disable Lint/MissingSuper
    @name = name
    @winner = status
    @role = role
    return unless name == ''

    @name = 'Major Zero'
  end

  def human_input(array)
    acceptable_input = %w[red yellow orange blue green purple]
    6.times do
      guess = ''
      until acceptable_input.any? { |color| guess.include?(color) } == true
        puts 'Invalid input, Try again!' if acceptable_input.any? do |color|
          guess.include?(color)
        end == false && guess != ''
        guess = gets.chomp.downcase
      end
      colorize(array, guess)
    end
  end

  def make_combination(code_array)
    puts 'What will be the code? Put the colors in ONE line at a time'
    puts "The available colors are #{Rainbow('red, ').color(:red)}#{Rainbow('orange, ').color(:orange)}#{Rainbow('yellow, ').color(:yellow)}#{Rainbow('blue, ').color(:navyblue)}#{Rainbow('green, ').color(:darkgreen)}and #{Rainbow('purple.').color(:purple)}"
    human_input(code_array)
    puts "Correct Code: #{code_array[0]}, #{code_array[1]}, #{code_array[2]}, #{code_array[3]}, #{code_array[4]}, #{code_array[5]}"
  end

  def guesses(guess_array)
    puts 'What do you think the code combination is? Put the colors in ONE line at a time'
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
  attr_accessor :winner, :role, :guess_history, :correct_places

  def initialize(name = 'CPU', status = false, role = 'code_keeper') # rubocop:disable Lint/MissingSuper
    @name = name
    @winner = status
    @role = role
    @guess_history = []
    @correct_places = []
  end

  def insert_combination(array)
    if role == 'guesser'
      3.times do
        random_number = rand(1..6)
        2.times do
          colorize(array, random_number)
        end
      end
    else
      6.times do
        random_number = rand(1..6)
        colorize(array, random_number)
      end
    end
  end

  def guesses(guess_array, old_guess, code_array)
    insert_combination(guess_array)
    check_for_color(guess_array, old_guess, code_array)
    correct_place?(guess_array, old_guess, code_array)
    mark_correct_places(guess_array, code_array)
    puts "CPU guessed the code: #{guess_array[0]}, #{guess_array[1]}, #{guess_array[2]}, #{guess_array[3]}, #{guess_array[4]}, #{guess_array[5]}" # rubocop:disable Layout/LineLength
  end

  def status_change
    self.winner = true
  end

  def role_change
    self.role = 'guesser'
  end

  def correct_place?(guess_array, old_guess, code_array)
    old_guess.each_with_index do |color_a, index_a|
      code_array.each_with_index do |color_b, index_b|
        if color_a == color_b && index_a == index_b
          guess_array.delete_at(index_a)
          guess_array.insert(index_a, color_a)
        end
      end
    end
  end

  def check_for_color(guess_array, old_guess, code_array)
    colors = [Rainbow('red').color(:red), Rainbow('orange').color(:orange),
              Rainbow('yellow').color(:yellow), Rainbow('blue').color(:navyblue),
              Rainbow('green').color(:darkgreen), Rainbow('purple').color(:purple)]
    colors.each do |color|
      next unless code_array.include?(color) == true && code_array.count(color) > old_guess.count(color)

      place = rand(0..5)

      place = rand(0..5) until guess_history.any? do |variation|
        variation[place] == color
      end == false && correct_places.include?(place) == false

      guess_array.delete_at(place)
      guess_array.insert(place, color)
    end
  end

  def mark_correct_places(guess_array, code_array)
    guess_array.each_index do |index|
      correct_places.push(index) if guess_array[index] == code_array[index] && correct_places.include?(index) == false
    end
  end
end
