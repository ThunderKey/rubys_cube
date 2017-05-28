require "spec_helper"

RSpec.describe RubysCube do
  unless ENV['SKIP_UI_TESTS'] == 'true'
    before do
      @cube = described_class.new
      @cube.start_ui
      wait_for do
        @renderer = @cube.instance_variable_get(:@ui).
          instance_variable_get(:@renderer)
      end.not_to eq nil
    end

    after do
      glfwSetWindowShouldClose window_handle, 1
      @cube.wait_for_ui
    end

    it 'has the correct amount of boxes' do
      expect(@renderer.instance_variable_get(:@_opengl_objects).size).to eq 6
    end

    def window_handle
      @renderer.window.instance_variable_get(:@handle)
    end
  end
end
