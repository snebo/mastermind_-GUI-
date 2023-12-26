# frozen_string_literal: true

# Handle player information
# class Player
#   attr_accessor :name, :type

#   # probably have maker and breaker methods so i can switch turns
#   # have an is_guesser
# end

# # Handles game logic
# class Game
#   @@slots = 4
#   def set_slots
#     # changes amount of guessing slots for the game
#     response = ''
#     until Array(3..9).include?(response.to_i)
#       print 'Enter the number of guessing slots -> '
#       response = gets.chomp
#     end
#     @@slots = response.to_i
#   end
# end

COLORS = %w[red blue yellow black green]
$guessed = false

def make_guess(m_guess, count)
  val = ''
  until COLORS.include?(val)
    print "\nEnter a valid color in slot #{count} -> "
    val = gets.chomp.downcase
  end
  m_guess.push(val)
end

def guess(m_guess, slots)
  puts 'Enter the colors in order, one by one'
  
  until $guessed # change this to 'guessed?''
    my_guess = [] # making sure its a new guess each time
    # making sure a valid color is guessed
    puts slots
    slots.times do |i|
      val = ''
      until COLORS.include?(val)
        print "\nGuess a valid color -> "
        val = gets.chomp.downcase
      end
      my_guess.push(val)
    end
    # check the guess
    check_guess(my_guess, m_guess, slots)
  end
  puts 'you guessed right!!'
end

def check_guess(my_g, m_g, slots)
  puts 'does this run'
  result = []
  dummy_guess = m_g.clone
  puts "checking #{my_g} vs #{m_g}"
  # first check the guess
  if my_g.eql?(m_g)
    $guessed = true
    return
  end
  # check matches
  slots.times do |i|
    if my_g[i] == m_g[i]
      result.push('black')
      dummy_guess[i] = nil
    end
  end
  # check wrong positions
  slots.times do |i|
    if dummy_guess.include?(my_g[i])
      idx = dummy_guess.find_index(my_g[i])
      dummy_guess[idx] = nil
      result.push('white')
      # pop the first match
    end
  end
  puts "result: #{result.join(', ')}"
end

slots = 0
m_guess = []
until Array(3..9).include?(slots)
  puts 'enter no of slots -> '
  slots = gets.chomp.to_i
end
puts "Choose from these colors: #{COLORS.join(', ').upcase}"
slots.times { |i| make_guess(m_guess, i + 1) }
puts "Makers guess: #{m_guess.inspect}" # to be hidden

guess(m_guess, slots)
