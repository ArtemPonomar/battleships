require "./player"

class Human < Player
  def put_ships_on_field
    puts "Example of a correct input: (0 5 vertical)"
    get_and_add_n_ships_with_size_l(1, 4)
    get_and_add_n_ships_with_size_l(0, 3)
    get_and_add_n_ships_with_size_l(0, 2)
    get_and_add_n_ships_with_size_l(1, 1)
  end

  def make_a_shot
    begin
      puts "Shoot where? (row column)"
      coordinates = gets.chomp.split(' ').map { |current| Integer(current) }
      report = @enemy_field.shoot(coordinates[0], coordinates[1])
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
        puts "Enter the row and column numbers of a ship's head and it's orientation (horizontal/vertical)"
        arguments = gets.chomp.split(' ');
        raise ArgumentError, 'spelling error in orientation' if arguments[2] != 'vertical' && arguments[2] != 'horizontal'
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

