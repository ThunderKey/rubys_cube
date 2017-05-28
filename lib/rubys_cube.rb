require_relative 'rubys_cube/version'

class RubysCube
  def initialize
  end

  def start_ui
    require_relative 'rubys_cube/ui'
    @ui = Ui.new(self)
    @ui_thread = Thread.new { @ui.start }
  end

  def wait_for_ui
    @ui_thread.join
  end
end
