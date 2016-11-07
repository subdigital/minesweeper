class LedDisplay 
	SCALE = 0.5

	LED_NUMBER_WIDTH = 39
	LED_NUMBER_HEIGHT = 69

	attr_accessor :x
	attr_accessor :y
	attr_reader :number
	attr_reader :num_digits

	def initialize(num_digits)
		load_sprites
		@num_digits = num_digits
		@number = 0
		@x = 0
		@y = 0
	end

	def width
		num_digits * LED_NUMBER_WIDTH * SCALE
	end

	def height
		LED_NUMBER_HEIGHT * SCALE
	end

	def load_sprites
		@sprites = Gosu::Image.load_tiles("assets/numbers.png", LED_NUMBER_WIDTH, LED_NUMBER_HEIGHT) 
	end

	def set_number(n)
		@number = n
	end

	def update

	end

	def draw
		text = number.to_s
		while text.length < num_digits
			text = "0" + text
		end

		num_digits.times do |i|
			char = text[i]
			digit = char.to_i
			s = @sprites[digit]
			dx = x + i * LED_NUMBER_WIDTH * SCALE
 			dy = y
			s.draw dx, dy, 0, SCALE, SCALE
		end
	end
end