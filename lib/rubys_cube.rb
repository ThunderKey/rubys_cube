require_relative 'rubys_cube/version'
require_relative 'rubys_cube/puzzle'
require_relative 'rubys_cube/orientation'

module RubysCube
  def self.solved
    Puzzle.new
  end

  def self.random
    puzzle = Puzzle.new
    # TODO: randomize
    puzzle
  end
end
