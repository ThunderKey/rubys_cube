require_relative 'spec_helper'

RSpec.describe RubysCube::Puzzle do
  unless ENV['SKIP_UI_TESTS'] == 'true'
    before do
      @cube = described_class.new
      @cube.start_gui
      wait_for do
        @renderer = @cube.instance_variable_get(:@gui).
          instance_variable_get(:@renderer)
      end.not_to eq nil
    end

    after do
      stop_ui
    end

    it 'has the correct amount of boxes' do
      expected_object_count = 3 * 3 * 3 + 1 # cubes + 1 room
      wait_for { @renderer.instance_variable_get(:@_opengl_objects).size }.to eq expected_object_count
    end

    it 'runs dispatched actions in the ui thread' do
      actual_ui_thread = nil
      expected_ui_thread = @cube.instance_variable_get :@gui_thread
      expect(actual_ui_thread).not_to eq expected_ui_thread

      @cube.gui.dispatcher << ->(gui) { actual_ui_thread = Thread.current }

      wait_for { actual_ui_thread }.to eq expected_ui_thread
    end

    def window_handle
      @renderer.window.instance_variable_get(:@handle)
    end

    def stop_ui
      if @renderer
        glfwSetWindowShouldClose window_handle, 1
        @cube.wait_for_gui
        @renderer = nil
      end
    end
  end
end
