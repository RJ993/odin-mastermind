require_relative './players'

def text_instructions(human, _cpu)
  puts "#{human.name}, The main objective is to guess the randomized combination of 6 colors.\nPut the colors in one by one. Do NOT try to put all the colors into one line. If you guess the colors in the correct order in 5 turns, you win!\nIf you can't guess, then the CPU wins."
  puts "The available colors are #{Rainbow('red, ').color(:red)}#{Rainbow('orange, ').color(:orange)}#{Rainbow('yellow, ').color(:yellow)}#{Rainbow('blue, ').color(:navyblue)}#{Rainbow('green, ').color(:darkgreen)}and #{Rainbow('purple.').color(:purple)}"
end

def winning?(human, cpu, code_array, guess_array)
  human.status_change if code_array == guess_array && human.role == 'guesser'
  return unless code_array == guess_array && cpu.role == 'guesser'

  cpu.status_change
end

def color_in_correct_place?(code_array, guess_array)
  guess_array.each_with_index do |color_a, index_a|
    code_array.each_with_index do |color_b, index_b|
      if color_a == color_b && index_a == index_b
        puts "Color #{index_a + 1}, which is #{color_a}, is in the right place!"
      end
    end
  end
end

def color_in_code?(code_array, guess_array)
  guess_array.uniq.each do |color_a|
    puts "#{color_a} is in the code!" if code_array.include?(color_a) == true
  end
end

def compare(human, cpu, code_array, guess_array, old_guess = [])
  winning?(human, cpu, code_array, guess_array)
  if human.role == 'guesser'
    color_in_correct_place?(code_array, guess_array)
    color_in_code?(code_array, guess_array)
  end
  return unless cpu.role == 'guesser'

  guess_array.each { |color| old_guess.push(color) }
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
