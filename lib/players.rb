require 'rainbow'

class Player
  
end

class HumanPlayer < Player
  attr_reader :name

  def initialize(name, status = false)
    @name = name
    @winner = status
  end
end

class ComputerPlayer < Player
  

  def initialize(name = 'CPU', status = false)
    @name = name
    @winner = status
  end
  def make_combination(code_array)
    5.times do
    random_number = rand(1..6)
    code_array.push(Rainbow('red').color(:red)) if random_number == 1
    code_array.push(Rainbow('orange').color(:orange)) if random_number == 2
    code_array.push(Rainbow('yellow').color(:yellow)) if random_number == 3
    code_array.push(Rainbow('blue').color(:navyblue)) if random_number == 4
    code_array.push(Rainbow('green').color(:darkgreen)) if random_number == 5
    code_array.push(Rainbow('purple').color(:purple)) if random_number == 6
    end
  end
end