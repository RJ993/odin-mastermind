require_relative './players'
require 'rainbow'

class Game
  attr_accessor :code_array, :guess_array, :human, :cpu

  def initialize
    @code_array = []
    @guess_array = []
    puts 'What is your name, Mastermind?'
    @human = HumanPlayer.new(gets.chomp)
    until @human.name.downcase != 'cpu'
      puts 'You are not a computer, please give yourself life. After all, It\'s the name that counts.'
      @human.name = gets.chomp
    end
    @cpu = ComputerPlayer.new
  end

  def guesser?
    puts "Who is going to be guesser, #{human.name} or CPU?"
    guesser = gets.chomp.downcase
    until [human.name.downcase, 'cpu'].include?(guesser)
      puts 'Invalid player, Try again.'
      guesser = gets.chomp.downcase
    end
    if guesser == human.name.downcase
      human_prep
    elsif guesser == 'cpu'
      cpu_prep
    end
  end

  def human_prep
    human.role = 'guesser'
    cpu.insert_combination(code_array)
    text_instructions(human, cpu)
    human_play(human, cpu, code_array, guess_array)
  end

  def cpu_prep
    cpu.role = 'guesser'
    human.make_combination(code_array)
    computer_play(human, cpu, code_array, guess_array)
  end

  def text_instructions(human, _cpu)
    puts "#{human.name}, The main objective is to guess the randomized combination of 6 colors.
    Put the colors in one by one. Do NOT try to put all the colors into one line.
    If you guess the colors in the correct order in 5 turns, you win! If you can't guess, then the CPU wins."
    puts "The available colors are #{Rainbow('red, ').color(:red)}#{Rainbow('orange, ').color(:orange)}#{Rainbow('yellow, ').color(:yellow)}#{Rainbow('blue, ').color(:navyblue)}#{Rainbow('green, ').color(:darkgreen)}and #{Rainbow('purple.').color(:purple)}"
  end

  def winning?(human, cpu, code_array, guess_array)
    human.status_change if code_array == guess_array && human.role == 'guesser'
    return unless code_array == guess_array && cpu.role == 'guesser'

    cpu.status_change
  end

  def compare(human, cpu, code_array, guess_array, old_guess = [])
    winning?(human, cpu, code_array, guess_array)
    if human.role == 'guesser'
      human.color_in_correct_place?(code_array, guess_array)
      human.color_in_code?(code_array, guess_array)
    end
    return unless cpu.role == 'guesser'

    guess_array.each { |color| old_guess.push(color) }
    cpu.guess_history.push(old_guess)
  end

  def human_play(human, cpu, code_array, guess_array)
    attempts = 0
    until human.winner == true || attempts == 5
      guess_array = []
      human.guesses(guess_array)
      attempts += 1
      compare(human, cpu, code_array, guess_array)
    end
    winning?(human, cpu, code_array, guess_array)
    return unless attempts == 5 && human.winner == false

    puts "Sorry, but the correct code was --> #{code_array[0]}, #{code_array[1]}, #{code_array[2]}, #{code_array[3]}, #{code_array[4]}, #{code_array[5]}"
    cpu.status_change
  end

  def computer_play(human, cpu, code_array, guess_array)
    attempts = 0
    old_guess = []
    until cpu.winner == true || attempts == 5
      guess_array = []
      cpu.guesses(guess_array, old_guess, code_array)
      old_guess = []
      attempts += 1
      compare(human, cpu, code_array, guess_array, old_guess)
    end
    winning?(human, cpu, code_array, guess_array)
    return unless attempts == 5 && cpu.winner == false

    human.status_change
  end

  def declare_winner(human, cpu)
    puts "#{human.name} is the true Mastermind!" if human.winner == true
    return unless cpu.winner == true

    puts 'CPU is the true mastermind!'
  end
end
