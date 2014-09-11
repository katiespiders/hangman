require "colorize"

class Game
  def initialize(words_file="words.txt")
    words = File.read(words_file).split(" ")

    index = rand(0...words.length) # can use Array.sample for this
    @word = words[index]
    while @word.length < 5
      index = rand(0...words.length)
      @word = words[index]
    end

    @already_guessed = []
    @guess = "_ " * @word.length
    @hangman = Hangman.new
  end


  def play_round
    won = false
    round = 0

    puts @hangman.art_list[round][:graphic]
    while round < (@hangman.boards.length-1) and not won
      show_current_guess

      if not get_guess
        round += 1
        puts @hangman.art_list[round][:graphic]
      end

      if not @guess.include? "_"
        won = true
        puts @guess
        abort "\nYou live to fight another day!"
      end
    end
    puts "\nI dunno why failing to guess the word #{@word.upcase} is punishable by death, but it is. Bad news for you."
  end

  def show_current_guess
    puts "\n"
    puts @guess
  end

  def show_already_guessed
    puts "\nAlready guessed: #{@already_guessed}\n"
  end

  def get_guess
    show_already_guessed
    print "\nGuess a letter: "
    letter = gets.chomp
    while @already_guessed.include? letter
      print "You already guessed #{letter}. Guess a different one: "
      letter = gets.chomp
    end

    @already_guessed << letter
    return check_guess(letter)

  end

  def check_guess(letter)
    indices = []
    found = false

    # there has to be a better way to do this
    i = 0
    (@word.length).times do
      if @word[i] == letter.downcase
        indices << i
        found = true
      end
      i += 1
    end

    indices.each do |index|
      @guess[index*2] = letter.upcase
    end

    return found
  end
end

class Hangman
  attr_accessor :art_list, :boards

  def initialize
    @boards = [:gallows, :head, :body, :left_arm, :right_arm, :left_leg, :right_leg, :dead]
    @art_list = {} # hash of hashes, indexed by number
    art_filename = "ascii_hangman.txt"
    art_file = File.new(art_filename)

    i = 0
    (@boards.length).times do
      graphic = []
      10.times { graphic << art_file.gets }
      board_hash = {graphic: graphic, name: @boards[i]}
      @art_list[i] = board_hash
      art_file.gets
      i += 1
    end
    art_file.close
  color
  end


  def color # This is ridiculously complicated and I could have used one string and filled in instance variables instead of having a different board for each body part but I am not going to go back and do that now

    # head
    @art_list[1][:graphic][2][13,3] = @art_list[1][:graphic][2][13,3].colorize(:red).blink

    # body
    @art_list[2][:graphic][3][14] = @art_list[2][:graphic][3][14].colorize(:red).blink

    @art_list[2][:graphic][4][14] = @art_list[2][:graphic][4][14].colorize(:red).blink

    # left arm
    @art_list[3][:graphic][3][13] = @art_list[3][:graphic][3][13].colorize(:red).blink

    # right arm
    @art_list[4][:graphic][3][15] = @art_list[4][:graphic][3][15].colorize(:red).blink

    # left leg
    @art_list[5][:graphic][5][13] = @art_list[5][:graphic][5][13].colorize(:red).blink

    # right leg
    @art_list[6][:graphic][5][15] = @art_list[6][:graphic][5][15].colorize(:red).blink
    @art_list[6][:graphic] << ["", "Last move!".colorize(:red).bold]

    # dead
    @art_list[7][:graphic][7] = @art_list[7][:graphic][7].chomp + " "
    i=5
    4.times do
      @art_list[7][:graphic][i][13,3] = @art_list[7][:graphic][i][13,3].colorize(:red).blink
      i += 1
    end
  end
end


g = Game.new
g.play_round
