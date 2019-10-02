class Cell
  attr_accessor :was_shot, :has_ship, :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @was_shot = false
    @has_ship = false
  end

  def to_s_with_fog_of_war
    return "." if was_shot && !has_ship
    return "_" if !was_shot && !has_ship
    return "_" if !was_shot && has_ship
    return "0" if was_shot && has_ship
  end

  def to_s
    return "." if was_shot && !has_ship
    return "_" if !was_shot && !has_ship
    return "O" if !was_shot && has_ship
    return "0" if was_shot && has_ship
  end
end

