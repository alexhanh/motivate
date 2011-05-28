# coding: utf-8
class AchievementsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @achievements = []
    for token in Achievement.TOKENS
      @achievements << Achievement.new(:token => token)
    end
  end
end