require 'hasu'
require 'cinch'
require 'dotenv'

Dotenv.load

Hasu.load 'game.rb'

registeredPlayers = {}

class MineSweeperBot < Cinch::Bot
  attr_reader :game

  def initialize(game)
    super()
    @game = game
    puts "Created a bot with a game: #{@game}"
  end

  def say(text)
    # irc.send text
  end

  def self.mineSweeperBot(game)
    MineSweeperBot.new(game) do
      configure do |c|
        c.server = ENV['IRC_SERVER']
        c.channels = [ENV['IRC_CHANNEL']]
        c.nick = ENV['IRC_NICK']
        c.password = ENV['IRC_PASSWORD']
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
  end
end
