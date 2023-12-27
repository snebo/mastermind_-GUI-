# frozen_string_literal: true

COLORS = %w[red blue yellow black green]

# Players: handle player information and scores
class Player
  @@player_no = 1

  attr_accessor :name, :maker

  def initialize(name, maker)
    @name = name
    @maker = maker #value here is true
    @pl_score = 0

    @@player_no += 1
  end
  def player_type
    @maker ? "is the code maker" : "is the code breaker"
  end
end

#Random method to get player info
def player_info
  $p_info = []
  res = ''
  print "player#{Player.class_eval '@@player_no'}, Enter your name-> "
  $p_info[0] = gets.chomp
  until res == 'y' || res == 'n'
    print 'Do you want to be the code breaker? (y,n) > '
    res = gets.chomp.downcase
  end
  $p_info[1] = res
end

# Game: handles game logic, rounds and game variables
class Game
  attr_accessor :slots

  def initialize (pl1, pl2)
    @slots = 0
    @pl1 = pl1
    @pl2 = pl2
    @m_guess = []
    @guessed = false
  end

  def set_slots
    puts '=' * 30
    until Array(3..9).include?(slots)
      print 'Enter no of slots -> '
      slots = gets.chomp.to_i
    end
    @slots = slots
  end

  def make_guess(count)
    val = ''
    until COLORS.include?(val)
      print "\nEnter a valid color in slot #{count} -> "
      val = gets.chomp.downcase
    end
    @m_guess.push(val)
  end

  def play_round
    @m_guess = [] # resets master guess at the start of each round

    if @pl1.maker 
      puts "Choose from these colors: #{COLORS.join(', ').upcase}"
      @slots.times { |i| self.make_guess( i + 1) }
      # puts "Makers guess: #{@m_guess.inspect}"
      self.guess
    end
  end

  def guess
    puts 'Enter the colors in order, one by one'
    until @guessed 
      my_guess = []
      # making sure a valid color is guessed
      @slots.times do
        val = ''
        until COLORS.include?(val)
          print 'Guess a valid color -> '
          val = gets.chomp.downcase
        end
        my_guess.push(val)
      end
      # check the guess
      check_guess(my_guess)
    end
    puts 'you guessed right!!'
  end

  def check_guess(my_g)
    result = []
    dummy_guess = @m_guess.clone
    puts "checking #{my_g} vs #{@m_guess}"
    # first check the guess
    if my_g.eql?(@m_guess)
      @guessed = true
      return
    end
    # check matches
    @slots.times do |i|
      if my_g[i] == @m_guess[i]
        result.push('black')
        dummy_guess[i] = nil
      end
    end
    # check wrong positions
    @slots.times do |i|
      if dummy_guess.include?(my_g[i])
        idx = dummy_guess.find_index(my_g[i])
        dummy_guess[idx] = nil
        result.push('white')
      end
    end
    puts "result: #{result.join(', ')}"
  end
end

puts 'Welcome to terminal Mastermind'
$p_info = []
player_info
player1 = Player.new($p_info[0], $p_info[1] == 'y')
# player two
player_info
player2 = Player.new($p_info[0], !player1.maker)

master_game = Game.new(player1, player2)
master_game.set_slots
