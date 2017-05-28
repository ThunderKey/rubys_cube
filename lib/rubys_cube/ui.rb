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

      setup_camera
      setup_cube
      setup_room
      setup_light

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
      (0..2).to_a.repeated_permutation(3).each do |x,y,z|
        box = Mittsu::Mesh.new(
          Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
          Mittsu::MeshBasicMaterial.new(color: @colors[rand(@colors.size)])
        )
        box.position.x = x - 1
        box.position.y = y - 1
        box.position.z = z - 1
        @scene.add box
      end
    end

    def setup_room
      room_material = Mittsu::MeshPhongMaterial.new(color: 0xffffff)
      room_material.side = Mittsu::BackSide
      room = Mittsu::Mesh.new(Mittsu::SphereGeometry.new(1.0), room_material)
      room.scale.set(10.0, 10.0, 10.0)
      @scene.add(room)
    end

    def setup_light
      # white, half intensity
      light = Mittsu::HemisphereLight.new(0xFFFFFF, 0xFFFFFF, 0.5)
      @scene.add(light)
    end
  end
end
