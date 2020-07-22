#gosu file
#
require 'gosu'
require_relative 'game_of_life.rb'

class GameOfLifeWindow < Gosu::Window
  def initialize(height=900, width=900)
    @height = height
    @width = width
    super height, width, false
    self.caption = "Game of life"

    @background_color = Gosu::Color.new(0xff6F6F6F)
    @alive_color = Gosu::Color.new(0xffF0F0F0)
    @dead_color = Gosu::Color.new(0xff6F6F6F)

    @cols = width/8 
    @rows = height/8

    @col_width = width/@cols
    @row_height = height/@rows
    
    @world = World.new(@cols, @rows)
    @game = Game.new(@world)
    @game.world.randomly_populate


  end

  def update
    @game.tick!
  end

  def draw
    draw_quad(0,0, @background_color,
              width, 0 , @background_color,
              width, height, @background_color,
              0, height, @background_color)

    @game.world.cells.each do |cell|
      if cell.alive?
        draw_quad((cell.x * @col_width), (cell.y * @row_height), @alive_color,
                  (cell.x * @col_width + (@col_width - 1)), (cell.y * @row_height), @alive_color,
                  (cell.x * @col_width + (@col_width - 1)), (cell.y * @row_height + (@row_height - 1)), @alive_color,
                  (cell.x * @col_width), (cell.y * @row_height + (@row_height - 1)), @alive_color)
      else
        draw_quad((cell.x * @col_width), (cell.y * @row_height), @dead_color,
                  (cell.x * @col_width + (@col_width - 1)), (cell.y * @row_height), @dead_color,
                  (cell.x * @col_width + (@col_width - 1)), (cell.y * @row_height + (@row_height - 1)), @dead_color,
                  (cell.x * @col_width), (cell.y * @row_height + (@row_height - 1)), @dead_color)

      end
    end
  end

  def needs_cursor?
    true
  end

end

GameOfLifeWindow.new.show
