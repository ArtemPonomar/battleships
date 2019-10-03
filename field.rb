require "./cell"
require "./ship"

class Field
  def initialize(size)
    @ships = Array.new
    @cells = Array.new
    (0...size).each { |i|
      new_row = Array.new
      (0...size).each { |j|
        new_row << Cell.new(i, j)
      }
      @cells << new_row
    }
  end

  def all_ships_are_destroyed?
    @ships.each { |ship| return false if !ship.is_destroyed? }
    true
  end

  def cell_was_shot?(i,j)
    @cells[i][j].was_shot
  end

  def add_ship(row, column, size, orientation)
    if !ship_inside_field?(row, column, size, orientation)
      raise ArgumentError, "Ship coordinates beyond the playing field border."
    end
    ship_location = Array.new
    (0...size).each { |i|
      curr_cell = nil
      curr_cell = @cells[row][column + i] if orientation == 'horizontal'
      curr_cell = @cells[row + i][column] if orientation == 'vertical'
      ship_location << curr_cell
    }
    new_ship = Ship.new(ship_location)
    if ship_can_be_placed?(new_ship)
      new_ship.location.each do |cell|
        cell.has_ship = true
      end
      @ships << new_ship
      return true
    end
    false
  end

  def shoot(x, y)
    if (x >= @cells.size || y >= @cells[0].size || x < 0 || y < 0)
      raise ArgumentError, "Coordinates beyond the playing field border."
    end
    raise ArgumentError, "This field was already shot at" if @cells[x][y].was_shot == true
    @cells[x][y].was_shot = true
    @ships.each do |ship|
      report = ship.report_damage(x, y)
      return report if report == 'damaged'
      if report == 'destroyed'
        surround_ship(ship)
        return report
      end
    end
    'missed'
  end

  def to_s_with_fog_of_war
    result = ""
    (0...@cells.size).each { |i|
      (0...@cells[0].size).each { |j|
        result += @cells[i][j].to_s_with_fog_of_war + ' '
      }
      result += "\n"
    }
    result
  end

  def to_s
    result = ""
    (0...@cells.size).each { |i|
      result += @cells[i].join(" ")
      result += "\n"
    }
    result
  end

  def coordinates_belong_to_field?(row, column)
    if row < @cells.size && row >= 0
      if column < @cells[0].size && column >= 0
        return true
      end
    end
    false
  end

  private

  def ship_inside_field? (row, column, size, orientation)
    if coordinates_belong_to_field?(row, column)
      if orientation == 'horizontal'
        return true if coordinates_belong_to_field?(row, column + size - 1)
      end
      if orientation == 'vertical'
        return true if coordinates_belong_to_field?(row + size - 1, column)
      end
    end
    false
  end

  def ship_can_be_placed?(ship)
    ship.location.each do |cell|
      if cell.has_ship == true # shouldn't be a ship where you want to place a new ship
        raise ArgumentError, 'placing a ship on top of existing one'
      end
    end
    get_surrounding_cells(ship).each do |cell|
      if cell.has_ship == true # shouldn't be a ship to close to a new ship
        raise ArgumentError, 'placing a ship too close to an existing one'
      end
    end
    true
  end

  def surround_ship(ship)
    get_surrounding_cells(ship).each { |cell| cell.was_shot = true }
  end

  def get_surrounding_cells(ship)
    result = Array.new
    ship.location.each do |cell|
      (cell.row - 1..cell.row + 1).each { |curr_i| #
        (cell.column - 1..cell.column + 1).each { |curr_j| #going over every cell in a radius of one cell
          if coordinates_belong_to_field?(curr_i, curr_j)
            curr_cell = @cells[curr_i][curr_j]
            if !ship.location.include?(curr_cell) #adding to result array, only if cell isn't a part of a current ship
              if !result.include?(curr_cell) #don't add cells, that are already in a result array
                result << curr_cell
              end
            end
          end
        }
      }
    end
    result
  end

end
#  to_delete
#
# f = Field.new(10)
# f.add_ship(0, 0, 4, 'horizontal')
# f.add_ship(2, 3, 3, 'vertical')
#
# p f.shoot(0, 2)
# p f.shoot(1, 0)
# p f.shoot(0, 0)
# p f.shoot(0, 3)
# p f.shoot(2, 3)
# f.shoot(0,1)
# p f.shoot(2, 4)
# p f.shoot(3, 3)
#
# puts f.to_s_with_fog_of_war