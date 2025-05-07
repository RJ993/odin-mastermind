require_relative 'lib/game_mechanics'
require_relative 'lib/players'
require 'rainbow'

code_array = []
guess_array = []

puts 'What is your name, Mastermind?'
human = HumanPlayer.new(gets.chomp)
cpu = ComputerPlayer.new
puts "Who is going to be guesser, #{human.name} or CPU?"
guesser = gets.chomp.downcase
until guesser == "#{human.name.downcase}" || guesser == 'cpu'
  puts 'Invalid player, Try again.'
  guesser = gets.chomp.downcase
end
if guesser == "#{human.name.downcase}"
  human.role = 'guesser'
  cpu.make_combination(code_array)
  human_play(human, cpu, code_array, guess_array)
end
if guesser == 'cpu'
  cpu.role = 'guesser'
  human.make_combination(code_array)
end
declare_winner(human, cpu)