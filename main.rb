require_relative 'lib/game_mechanics'
require_relative 'lib/players'
require 'rainbow'

code_array = []
guess_array = []

puts 'What is your name, Mastermind?'
human = HumanPlayer.new(gets.chomp)
until human.name.downcase != 'cpu'
  puts 'You are not a computer, please give yourself life. After all, It\'s the name that counts.'
  human.name = gets.chomp
end
cpu = ComputerPlayer.new
puts "Who is going to be guesser, #{human.name} or CPU?"
guesser = gets.chomp.downcase
until [human.name.downcase.to_s, 'cpu'].include?(guesser)
  puts 'Invalid player, Try again.'
  guesser = gets.chomp.downcase
end
if guesser == human.name.downcase.to_s
  human.role = 'guesser'
  cpu.insert_combination(code_array)
  text_instructions(human, cpu)
  human_play(human, cpu, code_array, guess_array)
end
if guesser == 'cpu'
  cpu.role = 'guesser'
  human.make_combination(code_array)
  computer_play(human, cpu, code_array, guess_array)
end
declare_winner(human, cpu)
