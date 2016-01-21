require 'hasu'
require 'cinch'

Hasu.load 'game.rb'

registeredPlayers = {}

class MineSweeperBot < Cinch::Bot
  attr_reader :game

  def initialize(game)
    super()
    @game = game
    puts "Created a bot with a game: #{@game}"
  end
end

game = Game.new

bot = MineSweeperBot.new(game) do
  configure do |c|
    c.server = "irc.twitch.tv"
    c.channels = ["#quantumproductions"]
    c.nick = "quantumproductions"
    c.password = "secret" 
  end
	
  on :message do |m, who, text| 
    debug m.user.nick
    debug m.message

    name = m.user.nick

    if (m.message == 'c1')
      m.reply "Moved."
    end

    if (m.message == 'play')
      registeredPlayers[name] = 1
    end

    if (m.message == 'sub') 
      registeredPlayers[name] = 100
    end

    if (m.message == 'status' || m.message == "s" || m.message == "stat")
      puts "bot is #{bot}"
      puts "bot game is #{bot.game}"
      puts "bot.@game.board.field: #{bot.game.board.field}"
    end

    if (m.message[0..4] == 'sweep')
      coordinateCommand = m.message.split('sweep')[1]
      puts "coordinateCommand#{coordinateCommand}"
      return if coordinateCommand.nil?
      coordinates = coordinateCommand.split(',')
      puts "coordinates: #{coordinates}"
      return if coordinates.length != 2
      x = Integer(coordinates[0]) rescue nil
      puts "x #{x}"
      return if x.nil?
      y = Integer(coordinates[1]) rescue nil
      puts "y #{y}"
      return if y.nil?
      bot.game.chat_select({x: x, y: y})
    end
  end

end

puts "Hello"

Thread.new {
  bot.start  
}

game.show

# puts "hi this works"

# while 1
# end
