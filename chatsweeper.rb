require_relative 'game'
require_relative 'bot'

class ChatSweeper
	attr_reader :bot_thread
	attr_reader :game
	attr_reader :bot

	def run
		@game = Game.new
		@bot = MineSweeperBot.mineSweeperBot(@game)
		start_bot
		@game.show
	end

	def start_bot
		@bot_thread = Thread.new { bot.start }
	end

end

chat_sweeper = ChatSweeper.new
chat_sweeper.run
