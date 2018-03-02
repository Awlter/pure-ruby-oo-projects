class Player
  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer
  def initialize
    # seems like very similar to Player... do we even need this?
  end

  def deal
    # does the dealer or the deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Deck
  def initialize
    reset
  end

  def reset
    @deck = []
    CARD::SUITS.each do |suit|
      CARD::FACES.each do |face|
        @deck << Card.new(suit, face)
      end
    end
  end

  def deal
    # does the dealer or the deck deal?
  end
end

class Card
  SUITS = ['H', 'D', 'S', 'C']
  FACES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(suit, face)
    @suit = suit
    @face = face
  end
end

class Game

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal_cards
    
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start