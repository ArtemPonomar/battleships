require "./player"

class Bot < Player
  @wounded_cells = nil

  def put_ships_on_field
    generate_and_add_n_ships_with_size_l(1, 4)
    generate_and_add_n_ships_with_size_l(2, 3)
    generate_and_add_n_ships_with_size_l(3, 2)
    generate_and_add_n_ships_with_size_l(4, 1)
    puts @my_field
  end

  def make_a_shot
    begin
      report = nil
      if @wounded_cells != nil
        report = finish_off
      else
        report = locate_target
      end
      return true if report == "damaged" || report == "destroyed"
      return false
    rescue ArgumentError => e
      retry
    end
  end

  private

  def locate_target
    random_i = rand(0..9)
    random_j = rand(0..9)
    report = shoot(random_i,random_j)
    if report == "destroyed"
      @wounded_cells = nil
    end
    if report == "wounded"
      @wounded_cells << [random_i, random_j]
    end
    report
  end

  def finish_off
    if @wounded_cells.size == 1

    end
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

  def

  def rand_orientation
    return 'vertical' if rand(0..1) == 0
    'horizontal'
  end
end