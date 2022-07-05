#Tic Tac Toe Game in Console
class Games
  @@turn = 0

  def initialize
    @Board = Array.new(3) { Array.new(3) { Hash.new() } }
    @player = Array.new(2) {Hash.new()}
    @gameOver = false
  end
  
  def setPlayers
    for i in (1..2)
      playerChar = String.new()
      puts "What is Player#{i}'s name?"
      playerName = gets.chomp
      playerName = playerName.strip.length > 0 ? playerName : "Player#{i}"
      puts "What letter character would you like to use?"
      loop do
        tempChar = gets.chomp
        
        if tempChar.strip.length > 0 && tempChar != playerChar && tempChar.match?(/[[:alpha:]]/) 
          playerChar = tempChar
          break
        else
          puts "Please try a different character."
        end
      end
      @player[i-1][:name] = playerName
      @player[i-1][:character] = playerChar
    end
  end

  def display
    puts @player
  end

  def createGame
    @gameOver = false
    @@turn = 0
    @Board.each_with_index do |row, rowIndex|
      row.each_with_index do |square, columnIndex|
        square[:value] = nil
        square[:key] = (rowIndex *3) + columnIndex + 1
        square[:rowValue] = 1 * (10 ** rowIndex)
        case square[:key] % 3
        when 1
          square[:columnValue] = 1
        when 2
          square[:columnValue] = 10
        when 0
          square[:columnValue] = 100
        end
      end
    end
  end
  
  def rowAndColumnCheck?
    rowScore = 0
    columnScore = 0
    #checks columns and rows
    @Board.each do |row|
      row.each do |square|
        if @player[@@turn % 2][:character] == square[:value]
          rowScore += square[:rowValue]
          columnScore += square[:columnValue]
        end
      end
    end
    if rowScore.to_s.include?("3") || columnScore.to_s.include?("3")
      return true
    else 
      return false
    end
  end

  def diagonalCheck?
    if ((@Board[0][0][:value] == @Board[1][1][:value] && @Board[0][0][:value] == @Board[2][2][:value]) || (@Board[0][2][:value] == @Board[1][1][:value] && @Board[0][2][:value] == @Board[2][0][:value])) && @Board[1][1][:value] != nil
      true
    else
      false
    end
  end

  def winner(player)
    if rowAndColumnCheck? || diagonalCheck?
      playerWin(@player[@@turn % 2][:name])
    elsif @@turn >= 8
      tieGame
    end
  end
  
  def taken?(key)
    row = ((key - 1) / 3).floor
    column = (key % 3) -1
    if (1..9).include?(@Board[row][column][:key].to_i)
      true
    else
      false
    end
  end

  def takeTurn
    puts "Enter the number for the square you would like to place you character..."
    key = 0
    loop do
      key = gets.chomp.to_i
      if (1..9).include?(key)
        if taken?(key)
          break
        else
          displayBoard
          puts "That spot is taken, please choose another."
        end
      else
        displayBoard
        puts "That is not a valid number. Please try again."
      end
    end
    row = (( key -1) / 3 ).floor
    column = (key % 3) -1
    @Board[row][column][:key] = @player[@@turn % 2][:character]
    @Board[row][column][:value] = @player[@@turn % 2][:character]
    
  end

  def startGame
    until @gameOver == true do
      puts "Turn #{@@turn + 1}: It's your turn #{@player[@@turn % 2][:name]}!"
      displayBoard
      takeTurn
      winner(@player[@@turn % 2][:character])
      @@turn += 1 
    end
    playAgain
  end

  def playAgain
    answer = ""
    loop do
      puts "Would you like to play again? Y / N"
      answer = gets.chomp.downcase
      puts answer
      if answer == "y"
        createGame
        blank_line(8)
        startGame
        break
      elsif answer =="n"
        puts "Thank you for playing!" #Refresh the page to play again."
        break
      end
    end
  end

  def displayBoard
    blank_line
    puts " #{@Board[0][0][:key]} | #{@Board[0][1][:key]} | #{@Board[0][2][:key]} "
    puts "---+---+---"
    puts " #{@Board[1][0][:key]} | #{@Board[1][1][:key]} | #{@Board[1][2][:key]} "
    puts "---+---+---"
    puts " #{@Board[2][0][:key]} | #{@Board[2][1][:key]} | #{@Board[2][2][:key]} "
    blank_line
  end

  def playerWin (player)
    @gameOver = true
    blank_line(8)
    displayBoard
    puts "#{player} wins!"
    puts ""
  end

  def tieGame
    @gameOver = true
    blank_line(8)
    displayBoard
    puts "It's a tie!"
    playAgain
  end

  def blank_line(number = 1)
    number.times do
      puts ""
    end
  end
end

games = Games.new()
games.setPlayers
games.createGame
games.startGame
