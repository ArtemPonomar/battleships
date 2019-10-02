require "./player"

class Bot < Player

  def put_ships_on_field
    generate_and_add_n_ships_with_size_l(1, 4)
    generate_and_add_n_ships_with_size_l(2, 3)
    generate_and_add_n_ships_with_size_l(3, 2)
    generate_and_add_n_ships_with_size_l(4, 1)
  end

  private

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