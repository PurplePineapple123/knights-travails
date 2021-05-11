require "matrix"
require "rgl/adjacency"
require "rgl/dot"
require "rgl/traversal"
require "rgl/dijkstra"

class Chess
  attr_accessor :board

  def initialize
    @board = Matrix[
      [1, 2, 3, 4, 5, 6, 7, 8],
      [9, 10, 11, 12, 13, 14, 15, 16],
      [17, 18, 19, 20, 21, 22, 23, 24],
      [25, 26, 27, 28, 29, 30, 31, 32],
      [33, 34, 35, 36, 37, 38, 39, 40],
      [41, 42, 43, 44, 45, 46, 47, 48],
      [49, 50, 51, 52, 53, 54, 55, 56],
      [57, 58, 59, 60, 61, 62, 63, 64]
    ]
    @moves = [[1, 2], [2, 1], [-1, -2], [-2, -1], [1, -2], [2, -1], [-1, 2], [-2, 1]].freeze
  end

  def possible_moves(start, ending)
    graph = RGL::DirectedAdjacencyGraph.new

    edge_weights = Hash.new
    coordinate_queue = []
    coordinate_queue.unshift start
    current = coordinate_queue[-1]

    while current != ending
      current = coordinate_queue[-1]

      @moves.each do |i|
        if current[0] + i[0] <= 7 && current[0] + i[0] >= 0 &&
           current[1] + i[1] <= 7 && current[1] + i[1] >= 0
          updated_coordinate = [current[0] + i[0], current[1] + i[1]]
          coordinate_queue.unshift updated_coordinate
          edge_weights.store([current, updated_coordinate], 1)
        end
      end
      p edge_weights
      coordinate_queue.pop
    end

    edge_weights.each { |(first_coordinate, second_coordinate), w| graph.add_edge(first_coordinate, second_coordinate) }
    #graph.print_dotted_on

    p graph.dijkstra_shortest_path(edge_weights, start, ending)
  end
end

test = Chess.new
test.possible_moves([0, 0], [3, 3])
