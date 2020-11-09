require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    charset = ('A'..'Z').to_a
    grid = []
    10.times { |_i| grid << charset.sample }
    @grid = grid
  end

  def score
    word = params[:word]
    grid = params[:grid].split(' ')
    grid_check = check_letters(word, grid)
    word_check = check_word(word)
    if grid_check && word_check
      @message = "Congrats #{word} is a valid #{word.length} letter word!"
    elsif grid_check
      @message = "Sorry but #{word} is not an english word!"
    elsif word_check
      @message = "Sorry but #{word} is not in the grid!"
    else
      @message = "Sorry but neither is #{word} in the grid nor is it an English word!"
    end
  end

  def check_letters(word, grid)
    grid_hash = {}
    grid.each { |letter| grid_hash.key?(letter.to_sym) ? grid_hash[letter.to_sym] -= 1 : grid_hash[letter.to_sym] = 0 }
    word.upcase.split('').each do |char|
      if grid_hash.keys.include?(char.to_sym)
        grid_hash[char.to_sym] += 1
      else
        return false
      end
    end
    grid_hash.values.each { |value| return false if value > 1 }
  end

  def check_word(word)
    base_url = "https://wagon-dictionary.herokuapp.com/"
    url = base_url + word
    web_file = open(url).read
    json = JSON.parse(web_file)

    json["found"] == true ? json : nil
  end
end
