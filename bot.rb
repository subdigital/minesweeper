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

  def message_coordinates(message, command)
    message.gsub! /[\(\)\s]/, ''
    coordinateCommand = message.split(command)[1]
    return nil if coordinateCommand.nil?
    coordinates = coordinateCommand.split(',')
    return nil if coordinates.length != 2
    x = Integer(coordinates[0]) rescue nil
    return nil if x.nil?
    y = Integer(coordinates[1]) rescue nil
    return nil if y.nil?
    return {x: x, y: y}
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
          coordinates = bot.message_coordinates(m.message, 'sweep')
          next if coordinates.nil?
          bot.game.chat_select(coordinates)
        end

        if (m.message[0..3] == 'flag')
          coordinates = bot.message_coordinates(m.message, 'flag')
          next if coordinates.nil?
          bot.game.chat_flag(coordinates)
        end

        if (m.message[0..5] == 'unflag')
          coordinates = bot.message_coordinates(m.message, 'unflag')
          next if coordinates.nil?
          bot.game.chat_unflag(coordinates)
        end
      end

    end
  end
end
