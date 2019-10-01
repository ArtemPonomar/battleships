require './field'

class Player
  attr_accessor :name, :my_field, :enemy_field
  def initialize(name)
    @name = name
  end
  def put_ships_on_field

  end
  def make_a_shot

  end
  def won?
    return enemy_field.all_ships_are_destroyed
  end
end