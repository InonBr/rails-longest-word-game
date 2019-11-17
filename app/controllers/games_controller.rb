require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @random_array = generate_array
  end

  def score
    @massage = test_all_conditions
  end

  private

  def generate_array
    random_array = []

    10.times { random_array << ('a'..'z').to_a.sample }

    random_array
  end

  def real_english?(user_word)
    url = "https://wagon-dictionary.herokuapp.com/#{user_word}"
    read_url = open(url).read
    result = JSON.parse(read_url)

    result['found']
  end

  def test_word(user_word, grid)
    random_arr = grid.downcase.split
    user_word.split('').each do |letter|
      return false unless random_arr.include?(letter)

      index_loc = random_arr.index(letter)
      random_arr.delete_at(index_loc)
    end
    true
  end

  def test_all_conditions
    if real_english?(params[:word]) && test_word(params[:word], params[:grid])
      "Good job! Your word is: #{params[:word]}"
    elsif test_word(params[:word], params[:grid]) == false
      "Sorry the word #{params[:word]} cannot be created by the
      list: #{params[:grid]}"
    else
      "Sorry the word #{params[:word]} is not a valid word!"
    end
  end
end
