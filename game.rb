require "./player"

class Game
  def play_game
    p1 = Human.new("Ivan")
    p2 = Bot.new("AIvan")
    p1.put_ships_on_field
    p2.put_ships_on_field
    current_player_turn = p1
    next_player_turn = p2
    loop do
      while current_player.make_a_shot
      end
      break if current_player.won?
      temp = current_player_turn
      current_player_turn = next_player_turn
      next_player_turn = temp
    end
    puts "Won player #{current_player_turn.name}"
  end
end