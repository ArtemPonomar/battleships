require "./cell"
require "./ship"

class Field
  def initialize(size)
    @ships = Array.new
    @cells = Array.new
    for i in (0...size)
      new_row = Array.new
      for j in (0...size)
        new_row << Cell.new(i, j)
      end
      @cells << new_row
    end
  end

  def cell_was_shot?(x, y)
    return @cells[x][y].was_shot
  end

  def cell_has_ship?(x, y)
    return @cells[x][y].has_ship
  end

  def add_ship(row_num, column_num, size, orientation)
    ship_location = Array.new
    for i in (0...size)
      curr_cell = nil
      curr_cell = @cells[row_num][column_num + i] if orientation == 'horizontal'
      curr_cell = @cells[row_num + i][column_num] if orientation == 'vertical'
      curr_cell.has_ship = true
      ship_location << curr_cell
    end
    new_ship = Ship.new(ship_location)
    @ships << new_ship
  end

  def shot(x, y)
    return false if @cells[x][y].was_shot == true
    @cells[x][y].was_shot = true
    @ships.each do |ship|
      report = ship.report_damage(x, y)
      return report if report == 'damaged'
      if report == 'destroyed'
    end
  end

  if ship.re
  end
end

def to_s
  result = ""
  for i in (0...@cells.size)
    result += @cells[i].join(" ")
    result += "\n"
  end
  result
end

end

f = Field.new(10)
f.add_ship(0, 0, 4, 'horizontal')
f.shot(0, 2)
f.shot(1, 0)
puts f