#this is the spec file for the game

require 'rspec'
require_relative 'game_of_life.rb'

RSpec.describe World do
  context 'Creating a new World' do
    world = World.new 
    cell = Cell.new(1,1)
    it 'should create a new world object' do
      expect(world.is_a?(World)).to eq true
    end
    it 'should respond to proper methods' do
      expect(world.respond_to?(:rows)).to eq true
      expect(world.respond_to?(:cols)).to eq true
      expect(world.respond_to?(:cell_grid)).to eq true
      expect(world.respond_to?(:live_neighbours_around_cell)).to eq true
      expect(world.respond_to?(:cells)).to eq true
      expect(world.respond_to?(:randomly_populate)).to eq true
      expect(world.respond_to?(:live_cells)).to eq true
    end
    it 'should create proper cell grid on initilization' do
        expect(world.cell_grid.is_a?(Array)).to eq true
        world.cell_grid.each do |row|
          expect(row.is_a?(Array)).to eq true
          row.each do |col|
            expect(col.is_a?(Cell)).to eq true
          end
        end
    end
    
    it 'should add all the cells to cells array' do
      expect(world.cells.count).to eq 9 
    end

    it 'should detect a neighbour to the north' do
      expect(world.cell_grid[0][1]) == be_dead
      world.cell_grid[0][1].alive = true
      expect(world.cell_grid[0][1]) == be_alive
      expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count).to eq 1 
      world.cell_grid[0][1].alive = false
    end
    it 'should detect a neighbour to the Noth-east' do
      world.cell_grid[cell.y-1][cell.x+1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y-1][cell.x+1].alive = false 
    end
    it 'should detect a neighbour to the east' do
      world.cell_grid[cell.y][cell.x+1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y][cell.x+1].alive = false 
    end
    it 'should detect a neighbour to the South-east' do
      world.cell_grid[cell.y+1][cell.x+1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y+1][cell.x+1].alive = false 

    end
    it 'should detect a neighbour to the Souht' do
      world.cell_grid[cell.y+1][cell.x].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y+1][cell.x].alive = false 

    end
    it 'should detect a neighbour to the South-weast' do
      world.cell_grid[cell.y+1][cell.x-1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y+1][cell.x-1].alive = false
    end
    it 'should detect a neighbour to the Weast' do
      world.cell_grid[cell.y][cell.x-1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y][cell.x-1].alive = false 
    end
    it 'should detect a neighbour to the Noth-weast' do
      world.cell_grid[cell.y-1][cell.x-1].alive = true
      expect(world.live_neighbours_around_cell(cell).count).to eq 1
      world.cell_grid[cell.y-1][cell.x-1].alive = false 
    end
    
    it 'should randomly populate the world' do
      world = World.new
      expect(world.live_cells.count).to eq  0 
      world.randomly_populate
      expect(world.live_cells.count).not_to be_zero 

    end
    
  end
 end
RSpec.describe Cell do
  context 'Creating a new cell' do
    cell = Cell.new
    it 'should create a new cell object' do
      expect(cell.is_a?(Cell)).to eq true
    end
    it 'should respond to proper methods' do
      expect(cell.respond_to?(:alive)).to eq true
      expect(cell.respond_to?(:x)).to eq true
      expect(cell.respond_to?(:y)).to eq true
      expect(cell.respond_to?(:alive?)).to eq true
      expect(cell.respond_to?(:die!)).to eq true
      expect(cell.respond_to?(:live!)).to eq true
    end
    it 'should initialize properly' do
      expect(cell.alive).to eq false
      expect(cell.x) == 0
      expect(cell.y) == 0
    end
  end
end
RSpec.describe Game do
  let!(:world) {World.new}
  context 'game context'do
    game = Game.new
    it 'should create a new Game object'do
      expect(game.is_a?(Game)).to eq true
    end
    it 'should respond to proper methods'do
      expect(game.respond_to?(:world)).to eq true
      expect(game.respond_to?(:seeds)).to eq true
    end
    it 'should initialize properly' do
      expect(game.world.is_a?(World)).to eq true
      expect(game.seeds.is_a?(Array)).to eq true
    end
    it 'should plant seeds properly' do
      game = Game.new(world, [[1,2],[0,2]])
      expect(world.cell_grid[1][2].alive?).to eq true 
      expect(world.cell_grid[0][2].alive?).to eq true
    end
  end

  context 'rules context' do
    game = Game.new  
    
    context 'Rule 1: Any live cell with fewer than two live neighbours dies, as if by underpopulation' do
      
      it 'should kill a live cell with no live neighbours' do
        world = World.new
        game = Game.new
        game.world.cell_grid[1][1].alive = true
        expect(game.world.cell_grid[1][1].alive?).to eq true
        game.tick!
        expect(game.world.cell_grid[1][1].alive?).to eq false 
      end
      
      it 'should kill a live cell with 1 live neighbours'do
        world = World.new 
        game = Game.new(world,[[1,0],[2,0]])
        game.tick!
        expect(world.cell_grid[1][0].alive?).to eq false
        expect(world.cell_grid[2][0].alive?).to eq false
      end
      
      it 'doesnt kill live cell with 2 live neighbours' do
        world = World.new
        game = Game.new(world,[[2,0],[1,1],[2,2]])
        game.tick!
        expect(world.cell_grid[1][1].alive?).to eq true
        expect(world.cell_grid[2][0].alive?).to eq false 
        expect(world.cell_grid[2][2].alive?).to eq false 
      end

    end
    context 'Rule 2:Any live cell with two or three live neighbours lives on to the next generation.' do
      it 'should keep a live cell with 2  neighbours' do
        world = World.new
        game = Game.new(world,[[0,1],[1,1],[2,1]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count) == 2
        game.tick!
        expect(world.cell_grid[1][1].alive?).to eq true
        expect(world.cell_grid[0][1].alive?).to eq false 
        expect(world.cell_grid[2][1].alive?).to eq false
      end
      it 'should keep a live cell with 3  neighbours' do
        world = World.new
        game = Game.new(world,[[0,1],[1,1],[2,1],[2,2]])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count) == 2
        game.tick!
        expect(world.cell_grid[1][1].alive?).to eq true
        expect(world.cell_grid[0][1].alive?).to eq false 
        expect(world.cell_grid[2][1].alive?).to eq true 
        expect(world.cell_grid[2][2].alive?).to eq true 
      end


    end
    context 'Rule 3: Any live cell with more than three live neighbours dies, as if by overpopulation.' do
      it 'should kill a live cell with more than 3 live neighbours' do
        world = World.new
        game = Game.new(world,[[0,0],[1,1],[1,0],[2,0],[2,2]])
        game.tick!
        expect(world.cell_grid[1][1].alive?).to  eq false
        expect(world.cell_grid[0][0].alive?).to  eq true 
        expect(world.cell_grid[1][0].alive?).to  eq true
        expect(world.cell_grid[2][2].alive?).to  eq false
        expect(world.cell_grid[2][0].alive?).to  eq true 
      end
    end
    context 'Rule 4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
      it 'should become live a cell with exactly 3 live neighbours' do
        world = World.new
        game = Game.new(world,[[0,1],[1,1],[2,1]])
        game.tick!
        expect(world.cell_grid[1][0].alive?).to  eq true 
        expect(world.cell_grid[1][2].alive?).to  eq true 
      end
    end
  end
end
