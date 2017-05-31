require_relative 'puzzle/cube'

module RubysCube
  class Puzzle
    attr_reader :gui

    def initialize
      @cube = Array.new(3) { Array.new(3) { Array.new(3) { Cube.new } } }
    end

    def gui?
      !gui.nil?
    end

    def rotate
     gui.dispatcher << ->(gui) { gui.rotate_cube } if gui?
    end

    def start_gui color_scheme: nil, spacing: nil, camera: nil
      require_relative 'gui'
      @gui = Gui.new(self, color_scheme: color_scheme, spacing: spacing, camera: camera)
      @gui_thread = Thread.new { gui.start }
      @gui_thread.abort_on_exception = true
    end

    def wait_for_gui
      @gui_thread.join
    end
  end
end
