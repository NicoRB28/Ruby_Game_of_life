#world file

class World
  attr_accessor :rows, :cols, :cell_grid, :cells

  def initialize(rows=3, cols=3)
      @rows = rows
      @cols = cols
      @cells = []
      @cell_grid =  Array.new(rows) do |row|
                      Array.new(cols) do |col|
                         cell =  Cell.new(col,row)
                         cells << cell
                         cell
                      end
                    end
  end
  
  def randomly_populate
    cells.each do |cell|
      cell.alive = [true, false].sample
    end
  end

  def live_cells
    cells.select {|cell| cell.alive }

  end

  def live_neighbours_around_cell(cell)
    live_neighbours = []
    #it detects a neighbour to the North
    if cell.y > 0
      candidate = self.cell_grid[cell.y - 1][cell.x]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the North-east
    if cell.y > 0 and cell.x < cols-1
      candidate = self.cell_grid[cell.y - 1][cell.x + 1]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the east
    if cell.x < cols-1
      candidate = self.cell_grid[cell.y][cell.x+1]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the South-east
    if cell.y < rows-1 and cell.x < cols-1
      candidate = self.cell_grid[cell.y + 1][cell.x + 1]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the South
    if cell.y < rows-1
      candidate = self.cell_grid[cell.y + 1][cell.x]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the South-weast
    if cell.y < rows-1 and cell.x > 0
      candidate = self.cell_grid[cell.y + 1][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the Weast
    if cell.x > 0
      candidate = self.cell_grid[cell.y][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end
    #it detects a neighbour to the North-weast
    if cell.y > 0 and cell.x > 0
      candidate = self.cell_grid[cell.y - 1][cell.x - 1]
      live_neighbours << candidate if candidate.alive?
    end

    live_neighbours
  end
end

