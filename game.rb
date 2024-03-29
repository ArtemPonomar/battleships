require "./player"
require "./human"
require "./bot"

class Game
  def initialize (player_name, bot_name)
    @p1 = Human.new(player_name)
    @p2 = Bot.new(bot_name)
    @p2.put_ships_on_field
    @p1.put_ships_on_field
    @p1.enemy_field = @p2.my_field
    @p2.enemy_field = @p1.my_field
  end

  def play_game
    current_player = @p1
    next_player = @p2
    loop do
      while current_player.make_a_shot
        puts "#{current_player.name}'s assumption of #{next_player.name}'s field is:"
        puts current_player.enemy_field.to_s_with_fog_of_war
        break if current_player.won?
      end
      break if current_player.won?
      puts "#{current_player.name}'s assumption of #{next_player.name}'s field is:"
      puts current_player.enemy_field.to_s_with_fog_of_war
      temp = current_player
      current_player = next_player
      next_player = temp
    end
    puts "Won player #{current_player.name}"
  end
end
