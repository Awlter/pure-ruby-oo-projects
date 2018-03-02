require 'pry'

# 
class Board
  attr_reader :square
  INITIAL_MARKER = ' '
  WINNING_CONDITION = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                      [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                      [[1, 5, 9], [3, 5, 7]]

  def initialize
    @square = {}
    reset
  end

  def reset
    (1..9).each { |key| square[key] = Square.new(INITIAL_MARKER) }
  end

  def draw
    puts "     |     |"
    puts "  #{square[1]}  |  #{square[2]}  |  #{square[3]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{square[4]}  |  #{square[5]}  |  #{square[6]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{square[7]}  |  #{square[8]}  |  #{square[9]}"
    puts "     |     |"
  end

  def set_square_at(key, marker)
    square[key].marker = marker
  end

  def unmarked_keys
    square.keys.select { |key| square[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_CONDITION.each do |condi|
      [TTTGame::HUMAN_MARKER, TTTGame::COMPUTER_MARKER].each do |mark|
        return mark if condi.all? { |key| square[key].marker == mark }
      end
    end
    nil
  end

  def []=(num, marker)
    square[num].marker = marker
  end
end

# 
class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def unmarked?
    @marker == Board::INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

# 
class Player
  attr_reader :marker, :name
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
    set_name
    @name
  end

  def add_score
    @score += 1
  end

  def set_name
    if @marker == TTTGame::HUMAN_MARKER
      @name = ['Bob', 'Steve', 'Bella', 'Jocab'].sample
    else
      @name = ['AI-30', 'All_blue', 'AlienX', 'No.007'].sample
    end
  end
end

#
class ComputerAI
  def choose(square)
    offense = 0
    defense = 0
    Board::WINNING_CONDITION.each do |condi|
      winning_marker = square.values_at(*condi).map(&:marker)
      offense = winning_marker.count(TTTGame::COMPUTER_MARKER)
      defense = winning_marker.count(TTTGame::HUMAN_MARKER)
      if offense == 2 && defense == 0
        return condi[winning_marker.index(Board::INITIAL_MARKER)]
      elsif defense == 2 && offense == 0
        return condi[winning_marker.index(Board::INITIAL_MARKER)]
      end
    end
    return 5 if square[5].marker == Board::INITIAL_MARKER
    nil
  end
end

# 
class TTTGame
  puts "Choose a marker you want to put on the board"
  HUMAN_MARKER = gets.chomp
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_accessor :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
    @computer_ai = ComputerAI.new
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?

        clear_and_display_board if human_turn?
      end
      add_score
      display_score
      display_result if [human.score, computer.score].include? 5
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private
  def display_welcome_message
    puts "Hi, #{human.name}. Welcome to Tic Tac Toe"
    puts ' '
  end

  def display_goodbye_message
    puts "Thanks for playing, goodbye"
    puts ''
  end

  def clear_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{human.name} is #{human.marker} | #{computer.name} is #{computer.marker}"
    puts ''
    board.draw
    puts ''
  end

  def joiner(unmarked_keys, delimiter = ', ', last_delimiter = 'or')
    result = unmarked_keys.join(delimiter)
    result = result.insert(-2, last_delimiter + ' ') if unmarked_keys.size >= 2
    result
  end

  def human_moves
    puts "Please choose a square from #{joiner(board.unmarked_keys)}."
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include? square
      puts 'Sorry, invalid number.'
    end

    board[square] = human.marker
  end

  def computer_moves
    move = @computer_ai.choose(board.square)
    move = board.unmarked_keys.sample if move == nil
    board.set_square_at(move, computer.marker)
  end

  def add_score
    case board.winning_marker
    when 'X' then human.add_score
    when 'O' then computer.add_score
    end
  end

  def display_score
    clear_and_display_board
    puts "Score: #{human.name} => #{human.score} | #{computer.name} => #{computer.score}"
  end

  def display_result
    if human.score == 5
      puts "#{human.name} won!"
    else
      puts "#{computer.name} won!"
    end
  end

  def play_again?
    puts 'Do you want to play again?(y/n)'
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts 'Sorry, must input y or n.'
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
    if [human.score, computer.score].include? 5
      human.score = 0
      computer.score = 0
    end
  end

  def display_play_again_message
    puts "Let's play again."
    puts ''
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def clear
    system 'clear'
  end
end

game = TTTGame.new
game.play
