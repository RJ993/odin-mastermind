require_relative 'lib/game_mechanics'
require_relative 'lib/players'
require 'rainbow'

code_array = []

puts 'What is your name, Mastermind?'
human = HumanPlayer.new(gets.chomp)
cpu = ComputerPlayer.new
text_instructions(human, cpu)
cpu.make_combination(code_array)