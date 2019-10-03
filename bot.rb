require "./player"

class Bot < Player

  def initialize(name)
    super (name)
    @damaged_cells = Array.new
  end

  def put_ships_on_field
    generate_and_add_n_ships_with_size_l(1, 4)
    generate_and_add_n_ships_with_size_l(2, 3)
    generate_and_add_n_ships_with_size_l(3, 2)
    generate_and_add_n_ships_with_size_l(4, 1)
  end

  def make_a_shot
    begin
      if @damaged_cells.size > 0
        target = get_possible_enemy_ship_locations.sample
      else
        target = [rand(0..9), rand(0..9)]
      end
      report = @enemy_field.shoot(target[0], target[1])
      puts "#{@name} shot at coordinates #{target[0] + 1}, #{target[1] + 1} and #{report} enemy ship."
      if report == "damaged" || report == "destroyed"
        @damaged_cells.clear if report == "destroyed"
        @damaged_cells << target if report == "damaged"
        return true
      end
      return false
    rescue ArgumentError => e
      retry
    end
  end

  private

  def get_possible_enemy_ship_locations
    result = Array.new
    result += get_possible_horizontal_enemy_ship_locations if get_possible_horizontal_enemy_ship_locations != nil
    result += get_possible_vertical_enemy_ship_locations if get_possible_vertical_enemy_ship_locations != nil
    result.compact
    result.each { |point| result.delete point unless @enemy_field.coordinates_belong_to_field?(point[0], point[1]) }
    result.each { |point| result.delete point if @enemy_field.cell_was_shot?(point[0], point[1]) }
    result
  end

  def get_possible_vertical_enemy_ship_locations
    result = Array.new

    curr_j = @damaged_cells[0][1]
    max_i = @damaged_cells[0][0]
    min_i = @damaged_cells[0][0]

    @damaged_cells.each do |cell|
      return nil if cell[1] != curr_j
      max_i = cell[0] if cell[0] > max_i
      min_i = cell[0] if cell[0] < min_i
    end

    result << [min_i - 1, curr_j]
    result << [max_i + 1, curr_j]
    result
  end

  def get_possible_horizontal_enemy_ship_locations
    result = Array.new

    curr_i = @damaged_cells[0][0]
    max_j = @damaged_cells[0][1]
    min_j = @damaged_cells[0][1]

    @damaged_cells.each do |cell|
      return nil if cell[0] != curr_i
      max_j = cell[1] if cell[1] > max_j
      min_j = cell[1] if cell[1] < min_j
    end

    result << [curr_i, max_j + 1]
    result << [curr_i, min_j - 1]
    result
  end

  def generate_and_add_n_ships_with_size_l(n, l)
    n.times do
      begin
        @my_field.add_ship(rand(0..9), rand(0..9), l, rand_orientation)
      rescue ArgumentError
        retry
      end
    end
  end

  def rand_orientation
    return 'vertical' if rand(0..1) == 0
    'horizontal'
  end

end
