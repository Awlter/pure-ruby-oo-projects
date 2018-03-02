require 'pry'

class Participants
  attr_accessor :cards, :name

  def initialize
    @cards = []
    set_name
  end

  def total
    total = 0
    cards.each do |card|
      if card.face == 'A'
        total += 11
      elsif card.face.to_i.zero?
        total += 10
      else
        total += card.face.to_i
      end
    end

    cards.select(&:ace?).count.times { total -= 10 if total > 21 }
    total
  end

  def hit(deck)
    add_card(deck)
  end

  def add_card(deck)
    @cards << deck.deal
  end

  def busted?
    total > 21
  end

  def show_cards
    puts "----#{name}'s cards----"
    cards.each do |card|
      puts "==> #{card}"
    end
    puts ''
    puts "The total is #{total}"
    puts ''
  end
end

class Player < Participants
  def set_name
    puts "Please input your name:"
    answer = nil
    loop do
      answer = gets.chomp.to_s.capitalize
      break unless answer.empty?
      puts "Invalid name."
    end
    self.name = answer
  end
end

class Dealer < Participants
  DEALER_NAME = %w(Riddle LittleSunny Smartegg Charger).freeze

  def set_name
    self.name = DEALER_NAME.sample
  end

  def show_card
    puts "----#{name}'s cards----"
    puts "==> #{cards[0]}"
    puts '??'
    puts ''
  end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    set_deck
  end

  def set_deck
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        cards << Card.new(suit, face)
      end
    end
  end

  def deal
    cards.shuffle.pop
  end
end

class Card
  attr_accessor :face
  SUITS = %w(H D S C).freeze
  FACES = %w(2 3 4 5 6 7 8 9 10 J Q K A).freeze

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{@face} of #{@suit}"
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    self.deck = Deck.new
    player.cards = []
    dealer.cards = []
  end

  def deal_cards
    2.times do
      player.add_card(deck)
      dealer.add_card(deck)
    end
  end

  def show_cards
    system 'clear'
    player.show_cards
    dealer.show_card
  end

  def player_turn
    loop do
      puts "Do you want to hit or stay(h/s)?"
      answer = nil
      loop do
        answer = gets.chomp
        break if %w(h s).include? answer
      end

      if answer == 's'
        puts "#{player.name} choose to stay."
        puts ''
        break
      elsif answer == 'h'
        player.hit(deck)
        show_cards
        break if player.busted?
      end
    end
  end

  def dealer_turn
    puts "It's #{dealer.name}'s turn."

    loop do
      break if dealer.total > 17
      dealer.add_card(deck)
    end

    dealer.show_cards
  end

  def show_result
    if player.busted?
      puts "#{player.name} busted. #{dealer.name} won!"
    elsif dealer.busted?
      puts "#{dealer.name} busted. #{player.name} won!"
    elsif player.total > dealer.total
      puts "Player won!"
    elsif player.total < dealer.total
      puts "Dealer won!"
    else
      puts "It's a tie."
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Want to play again?(y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer
      "Invalid input."
    end

    answer == 'y'
  end

  def start
    loop do
      deal_cards
      show_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
      reset
    end
  end
end

twenty_one = Game.new
twenty_one.start
