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
    if (true) #вставить проверку, можно ли там поставить корабль
      new_ship.location.each do |cell|
        cell.has_ship = true
      end
      @ships << new_ship
      return true
    end
    return false
  end

  def shot(x, y)
    return false if @cells[x][y].was_shot == true
    @cells[x][y].was_shot = true
    @ships.each do |ship|
      report = ship.report_damage(x, y)
      return report if report == 'damaged'
      if report == 'destroyed'
        surround_ship(ship)
        return report
      end
    end
    return 'missed'
  end

  def new_ship_valid?

  end

  def surround_ship(ship)
    get_surrounding_cells(ship).each { |cell| cell.was_shot = true}
  end

  def get_surrounding_cells(ship)
    result = Array.new
    ship.location.each do |cell|
      root_i = cell.row
      root_j = cell.column
      for i_offset in (-1..1)         #
        for j_offset in (-1..1)       #going over every cell in a radius of one cell
          curr_i = root_i + i_offset  #
          curr_j = root_j + j_offset  #
          if curr_i < @cells.size && curr_i >= 0      #checking if index i out of bounds
            if curr_j < @cells[0].size && curr_j >= 0 #checking if index j out of bounds
              curr_cell = @cells[curr_i][curr_j]
              if !ship.location.include?(curr_cell)   #adding to result array, only if cell isn't a part of a current ship
                if !result.include?(curr_cell)        #don't add cells, that are already in a result array
                  result << curr_cell
                end
              end
            end
          end
        end
      end
    end
    result
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
p f.add_ship(0, 0, 4, 'horizontal')
p f.shot(0, 2)
p f.shot(1, 0)
p f.shot(0, 0)
p f.shot(0, 1)
p f.shot(0, 3)
puts f