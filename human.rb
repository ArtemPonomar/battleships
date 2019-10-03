require "./player"

class Human < Player
  def put_ships_on_field
    puts "Example of a correct input: (1 10 vertical)"
    get_and_add_n_ships_with_size_l(1, 4)
    get_and_add_n_ships_with_size_l(2, 3)
    get_and_add_n_ships_with_size_l(3, 2)
    get_and_add_n_ships_with_size_l(4, 1)
  end

  def make_a_shot
    begin
      puts "Shoot where? (row column)"
      coordinates = gets.chomp.split(' ').map { |current| Integer(current) - 1}
      report = @enemy_field.shoot(coordinates[0], coordinates[1])
      puts "#{@name} shot at coordinates #{coordinates[0] + 1}, #{coordinates[0] + 1} and #{report} enemy ship."
      return true if report == "damaged" || report == "destroyed"
      return false
    rescue ArgumentError => e
      puts e.message
      retry
    end
  end

  private

  def get_and_add_n_ships_with_size_l(n, l)
    puts "Entering the ships with size = #{l}"
    n.times do
      begin
        puts "Enter the row and column numbers of a ship's head and it's orientation ('h' for horizontal and 'v' for vertical)"
        arguments = gets.chomp.split(' ');
        raise ArgumentError, 'spelling error in orientation' if arguments[2] != 'v' && arguments[2] != 'h'
        arguments[2] = "vertical" if arguments[2] == 'v'
        arguments[2] = "horizontal" if arguments[2] == 'h'
        @my_field.add_ship(Integer(arguments[0]) - 1, Integer(arguments[1]) - 1, l, arguments[2])
      rescue ArgumentError => e
        puts "ERROR: " + e.message
        retry
      ensure
        puts @my_field
      end
    end
  end
end

