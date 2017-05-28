require 'mittsu'

class RubysCube
  class Ui
    DEFAULT_COLORS = [
      0xFFFFFF, # white
      0xB71234, # red
      0x009B48, # green
      0xF55500, # orange
      0x0046AD, # blue
      0xFFD500, # yellow
    ]

    def initialize cube, colors: DEFAULT_COLORS, width: 800, height: 600
      raise "there must be exactly 6 colors: #{colors.inspect}" if colors.size != 6
      @cube = cube
      @colors = colors.freeze

      @screen_width = width
      @screen_height = height
      @screen_aspect = @screen_width.to_f / @screen_height.to_f
    end

    def start
      @renderer = Mittsu::OpenGLRenderer.new width: @screen_width, height: @screen_height, title: %q{Ruby's Cube}

      @scene = Mittsu::Scene.new
      #@scene.override_material = Mittsu::MeshBasicMaterial.new(color: 0xDDDDDD)

      setup_camera
      setup_cube

      @renderer.window.run do
        @renderer.render(@scene, @camera)
      end
    end

    private

    def setup_camera
      @camera = Mittsu::PerspectiveCamera.new(75.0, @screen_aspect, 0.1, 1000.0)
      @camera.position.z = 5.0
      @camera.position.y = 2.0

      position_start = nil
      original_camera_position = nil
      @renderer.window.on_mouse_button_pressed do |button, position|
        original_camera_position = @camera.position
        position_start = position
      end
      @renderer.window.on_mouse_button_released do |button, position|
        position_start = nil
      end
      @renderer.window.on_mouse_move do |position|
        if position_start
          puts "#{position_start.x} - #{position.x} = #{position_start.x - position.x}"
          @camera.position.x = original_camera_position.x - (position_start.x - position.x) / 1000
          @camera.position.y = original_camera_position.y - (position_start.y - position.y) / 1000
        end
      end
    end

    def setup_cube
      @colors.each_with_index do |c, i|
        box = Mittsu::Mesh.new(
          Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
          Mittsu::MeshBasicMaterial.new(color: c)
        )
        box.position.x = (i * 1.0) - @colors.count / 2.0
        @scene.add box
      end
    end
  end
end
