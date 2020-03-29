class ConnectFour
  attr_accessor :current_player, :row_counter, :board

  Token = Struct.new(:color)

  def initialize
    @board = {}
    @player1 = "Red"
    @player2 = "Blue"
    @current_player = @player1
    @row_counter = []
    7.times { @row_counter << 0 } #Keeps track of tokens per row
  end

  def calculate_possible_lines(starting_token)
    x = starting_token[0]
    y = starting_token[1]
    possible_lines = []
    # Vertical line
    line = [[x + 0, y + 0], [x + 0, y + 1], [x + 0, y + 2], [x + 0, y + 3]]
    possible_lines << line unless out_of_bounds?(line)
    # Horizontal line
    line = [[x + 0, y + 0], [x + 1, y + 0], [x + 2, y + 0], [x + 3, y + 0]]
    possible_lines << line unless out_of_bounds?(line)
    # Diagonal line
    line = [[x + 0, y + 0], [x + 1, y + 1], [x + 2, y + 2], [x + 3,y + 3]]
    possible_lines << line unless out_of_bounds?(line)
    # Reverse diagonal line
    line = [[x + 0, y + 0], [x - 1, y + 1], [x - 2, y + 2], [x - 3,y + 3]]
    possible_lines << line unless out_of_bounds?(line)
    possible_lines
  end

  def start_game
    victory = false
    42.times do
      puts "It's #{@current_player}'s turn"
      puts "Select a row"

      input = gets.chomp
      break if input == "exit"
      input = check_input(input[0])

      place_token(input.to_i)

      print_board

      #Looks for a winner only if there's atleast 7 tokens
      if @board.length >= 7
        if player_won?
          victory = true
          puts "Woot! #{@current_player} won!"
          break
        end
      end

      next_turn
    end
    puts "its a draw!" unless victory
  end

  # Creates an instance of token in the desired row
  # using the number of tokens on that row to find the next free slot
  def place_token(location)
    location -= 1
    x = location
    y = @row_counter[location]
    @board[[x, y]] = Token.new(@current_player)
    @row_counter[location] += 1
  end

  def check_input(input)
    input = valid_row?(input.to_i)
    if input.to_i != (1..7)
      while !input.to_i.between?(1, 7)
        puts "Enter a number between 1 and 7"
        input = gets.chomp[0].to_i
        input = valid_row?(input)
      end
    end
    return input
  end

  # If the selected row is full changes the input to a wrong number
  # so the user is asked for a new input
  def valid_row?(row)
    if @row_counter[row - 1] == nil
      puts "Row invalid"
      return 9
    elsif @row_counter[row - 1] > 5
      puts "Row full"
      return 9
    else
      return row
    end
  end

  # Prevents adding out of the board lines
  def out_of_bounds?(line)
    line.each do |location|
      return true unless location[0].between?(0, 6)
      return true unless location[1].between?(0, 5)
    end
    false
  end

  # Prints the board creating a new line at the end of each row
  def print_board
    6.times do |y|
      y = 5 - y # To print from top to bottom
      7.times do |x|
        if @board[[x, y]] == nil
          x == 6 ? (puts "(   )") : (print "(   )")
        else
          # Prints only the 3 first letters of each color to keep board alignment
          x == 6 ? (puts "(#{@board[[x, y]].color[0, 3]})") : (print "(#{@board[[x, y]].color[0, 3]})")
        end
      end
    end
  end

  def next_turn
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  #Checks if any of the possible lines is all of the same color
  def player_won?
    victory = false
    @board.each do |key, value|
      victory = calculate_possible_lines(key).any? do |line|
      	line.all? do |location|
          next if @board[location] == nil
          @board[location].color == @current_player
      	end
      end
      return true if victory == true
    end
    false
  end

end

#my_game = ConnectFour.new
#my_game.start_game
