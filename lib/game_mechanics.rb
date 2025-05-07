require_relative './players'


def text_instructions(human, cpu)
  puts "#{human.name}, The main objective is to guess the randomized combination of 5 colors.\nPut the colors in one by one. Do NOT try to put all the colors into one line. If you guess the colors in the correct order in 6 turns, you win!\nIf you can't guess, then the CPU wins."
  puts "The available colors are " + Rainbow('red, ').color(:red) + Rainbow('orange, ').color(:orange) + Rainbow('yellow, ').color(:yellow) + Rainbow('blue, ').color(:navyblue) + Rainbow('green, ').color(:darkgreen) + "and " + Rainbow('purple.').color(:purple)
end

def winning?(human, cpu, code_array, guess_array)
  if code_array == guess_array && human.role == 'guesser'
    human.status_change
  end
  if code_array == guess_array && cpu.role == 'guesser'
    cpu.status_change
  end 
end

def color_in_correct_place?(code_array, guess_array)
  guess_array.each_with_index do |color_A, index_A|
    code_array.each_with_index do |color_B, index_B|
      if color_A == color_B && index_A == index_B
        puts "Color #{index_A + 1}, which is #{color_A}, is in the right place!"
      end
    end
  end
end

def color_in_code?(code_array, guess_array)
  guess_array.uniq.each do |color_A|
      if code_array.include?(color_A) == true
        puts "#{color_A} is in the code!"
      end
  end
end

def compare(human, cpu, code_array, guess_array)
  winning?(human, cpu, code_array, guess_array)
  if human.role = 'guesser'
    color_in_correct_place?(code_array, guess_array)
    color_in_code?(code_array, guess_array)
  end
end

def human_play(human, cpu, code_array, guess_array)
  attempts = 0
  until human.winner == true || attempts == 6
    guess_array = []
    human.guesses(guess_array)
    attempts += 1
    compare(human, cpu, code_array, guess_array)
  end
  winning?(human, cpu, code_array, guess_array)
  if attempts == 6 && human.winner == false
    cpu.status_change
  end
end

#insert computer_play method here.

def declare_winner(human, cpu)
  if human.winner == true
    puts "#{human.name} is the true Mastermind!"
  end
  if cpu.winner == true
    puts "CPU is the true mastermind!"
  end
end