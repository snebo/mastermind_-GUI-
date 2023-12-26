# frozen_string_literal: true

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

  until $guessed 
    my_guess = []
    # making sure a valid color is guessed
    slots.times do
      val = ''
      until COLORS.include?(val)
        print 'Guess a valid color -> '
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
    end
  end
  puts "result: #{result.join(', ')}"
end

slots = 0
m_guess = []
until Array(3..9).include?(slots)
  print 'enter no of slots -> '
  slots = gets.chomp.to_i
end
# One round
puts "Choose from these colors: #{COLORS.join(', ').upcase}"
slots.times { |i| make_guess(m_guess, i + 1) }
puts "Makers guess: #{m_guess.inspect}" # to be hidden
guess(m_guess, slots)
