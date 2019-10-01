class Ship
attr_accessor :location, :state
  def initialize(location)
    @location = location
  end

  def report_damage(x,y)
    @location.each do |cell|
      if cell.row == x && cell.column == y
        return 'destroyed' if is_destroyed?
        return 'damaged' if !is_destroyed?
      end
    end
    return 'missed'
  end

  def is_destroyed?
    each do |cell|
      return false if cell.was_hit == false
    end
    return true
  end
end