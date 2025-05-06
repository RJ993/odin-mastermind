require_relative './players'


def text_instructions(human, cpu)
  puts "#{human.name}, The main objective is to guess the randomized combination of colors.\nIf you guess the colors in the correct order in under 12 turns, you win!\nIf you can't guess, then the CPU wins."
end