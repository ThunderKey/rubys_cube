require_relative 'rubys_cube/version'

class RubysCube
  attr_reader :gui

  def initialize
  end

  def start_gui color_scheme: nil, spacing: nil, camera: nil
    require_relative 'rubys_cube/gui'
    @gui = Gui.new(self, color_scheme: color_scheme, spacing: spacing, camera: camera)
    @gui_thread = Thread.new { @gui.start }
    @gui_thread.abort_on_exception = true
  end

  def wait_for_gui
    @gui_thread.join
  end
end
