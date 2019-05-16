require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    session[:total] = 0 if session[:total].nil?
    @answer = params[:play]
    @grid = params[:grid]
    @included = included?(@answer.upcase, @grid)
    @english = english_word?(@answer)
    @word_score = word_score(@answer)
    session[:total] += @word_score
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def word_score(guess)
    guess.split('').count.to_i
  end
end
