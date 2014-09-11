require "colorize"
$debug = "*" * 40

class Game
  attr_accessor :word, :hangman


  def initialize(words_file="words.txt")
    words = File.read(words_file).split(" ")

    index = rand(0...words.length)
    @word = words[index]
    while @word.length < 5
      index = rand(0...words.length)
      @word = words[index]
    end

    @hangman = Hangman.new
  end



end

class Hangman
  attr_accessor :art_list

  def initialize
    @stage_names = [:gallows, :head, :body, :left_arm, :right_arm, :left_leg, :right_leg]
    @art_list = {} # hash of hashes, indexed by number
    art_filename = "ascii_hangman.txt"
    art_file = File.new(art_filename)

    i = 0
    (@stage_names.length).times do
      graphic = []
      8.times { graphic << art_file.gets }
      stage_hash = {graphic: graphic, name: @stage_names[i]}
      @art_list[i] = stage_hash
      art_file.gets
      i += 1
    end
    art_file.close
  color
  end

  def color

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
  end
end


g = Game.new
