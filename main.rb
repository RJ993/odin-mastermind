require_relative 'lib/game_mechanics'
require_relative 'lib/players'
require 'rainbow'

game = Game.new
game.guesser?
game.declare_winner(game.human, game.cpu)
