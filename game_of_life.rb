#basic faile of the game
#
require_relative 'world.rb'
require_relative 'cell.rb'

class Game
  attr_accessor :world, :seeds
  def initialize(world=World.new, seeds=[])
    @world = world
    @seeds = seeds

    seeds.each do |seed|
      world.cell_grid[seed[0]][seed[1]].alive = true
    end
  end

  def tick!
    next_round_live_cells = []
    next_round_dead_cells = []

    world.cells.each do |cell|

      #rule 1
      if cell.alive? and world.live_neighbours_around_cell(cell).count < 2
        next_round_dead_cells << cell
      #Rule 3
      end
      #Rule 2
      if cell.alive? and ([2, 3].include? world.live_neighbours_around_cell(cell).count)
        next_round_live_cells << cell
      end
     #Rule 3 
      if cell.alive? and world.live_neighbours_around_cell(cell).count > 3
        next_round_dead_cells << cell
      end
      #Rule 4
      if cell.dead? and world.live_neighbours_around_cell(cell).count == 3
        next_round_live_cells << cell
      end
    end
    
    next_round_dead_cells.each do |dead_cell|
      dead_cell.die!
    end
    
    next_round_live_cells.each do |live_cell|
      live_cell.live!
    end

  end
end

