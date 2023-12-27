# frozen_string_literal: true

COLORS = %w[red blue yellow black green]

# Players: handle player information and scores
class Player
  @@player_no = 1

  attr_accessor :name, :maker, :pl_score

  def initialize(name, maker)
    @name = name
    @maker = maker #value here is true
    @pl_score = 0

    @@player_no += 1
  end

  def player_type
    @maker ? "is the code maker" : "is the code breaker"
  end

  def add_score
    @pl_score += 1
  end
end

# Random method to get player info
def player_info
  $p_info = []
  res = ''
  print "player#{Player.class_eval '@@player_no'}, Enter your name-> "
  $p_info[0] = gets.chomp
  until res == 'y' || res == 'n'
    print 'Do you want to be the code maker? (y,n) > '
    res = gets.chomp.downcase
  end
  $p_info[1] = res
end

# Game: handles game logic, rounds and game variables
class Game
  attr_accessor :slots

  def initialize (pl1, pl2)
    @slots = 0
    # @pl1 = pl1
    # @pl2 = pl2
    if pl1.maker
      @maker = pl1
      @breaker = pl2
    else
      @maker = pl2
      @breaker = pl1
    end
    @m_guess = []
    @result = []
    @guessed = false
    @keep_play = true
  end

  def set_slots
    puts '=' * 30
    slots = 0
    until Array(3..9).include?(slots)
      print 'Enter no of slots ->'
      slots = gets.chomp.to_i
    end
    @slots = slots
  end

  def play
    chk = ''
    while @keep_play
      self.play_round
      until chk == 'y' || chk == 'n'
        puts 'Keep playing? (y,n) -> '
        chk = gets.chomp.downcase
      end
      chk == 'n' ? @keep_play =false : nil
    end
  end

  def make_guess(count)
    val = ''
    until COLORS.include?(val)
      print "\n#{@maker.name} Enter a valid color in slot #{count} -> "
      val = gets.chomp.downcase
    end
    @m_guess.push(val)
  end

  def play_round
    @m_guess = [] # resets master guess at the start of each round
    @guessed = false
    if @maker.maker 
      puts "Choose from these colors: #{COLORS.join(', ').upcase}"
      @slots.times { |i| self.make_guess(i + 1) }
      self.guess
    end
  end

  def guess
    guesses = 1
    until @guessed || guesses > 6
      system('clear') || system('cls')
      p @result
      puts "Codes broken by #{@breaker.name}: #{@breaker.pl_score}"
      puts '=' * 30
      my_guess = []
      # making sure a valid color is guessed
      @slots.times do
        val = ''
        until COLORS.include?(val)
          print "#{@breaker.name} Guess a valid color -> "
          val = gets.chomp.downcase
        end
        my_guess.push(val)
      end
      # check the guess
      check_guess(my_guess)
      guesses += 1
    end

    if @guessed
      puts 'you guessed right!!'
      @breaker.add_score
    else
      puts 'you ran out of guesses :('
    end
  end

  def check_guess(my_g)
    @result = []
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
        @result.push('black')
        dummy_guess[i] = nil
      end
    end
    # check wrong positions
    @slots.times do |i|
      if dummy_guess.include?(my_g[i])
        idx = dummy_guess.find_index(my_g[i])
        dummy_guess[idx] = nil
        @result.push('white')
      end
    end
    puts "result: #{@result.join(', ')}"
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
master_game.play
