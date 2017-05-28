require 'mittsu'

class RubysCube
  class Ui
    CAMERA_DISTANCE = 5.0

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

    def screen_width
      @renderer ? @renderer.window.instance_variable_get(:@width) : @screen_width
    end

    def screen_height
      @renderer ? @renderer.window.instance_variable_get(:@height) : @screen_height
    end

    def start
      @renderer = Mittsu::OpenGLRenderer.new width: screen_width, height: screen_height, title: %q{Ruby's Cube}

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
      rotate_camera 0.2, 0.2

      position_start = nil
      @renderer.window.on_mouse_button_pressed do |button, position|
        original_camera_position = @camera.position
        position_start = position
      end
      @renderer.window.on_mouse_button_released do |button, position|
        position_start = nil
      end
      @renderer.window.on_mouse_move do |position|
        if position_start
          rotate_camera(
            2 * (position_start.x - position.x) / screen_width,
            2 * (position_start.y - position.y) / screen_height,
          )
          position_start = position
        end
      end
    end

    def setup_cube
      (0..2).to_a.repeated_permutation(3).each do |x,y,z|
        box = Mittsu::Mesh.new(
          Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
          Mittsu::MeshBasicMaterial.new(color: @colors[(x + y + z) % @colors.size])
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

    # 1 = 360 degrees
    def rotate_camera move_x, move_y
      circumference = 2.0 * Math::PI * CAMERA_DISTANCE
      current_x = @camera.position.x / circumference
      current_y = @camera.position.y / circumference
      radius_x = (current_x + move_x) * 2 * Math::PI
      radius_y = (current_x + move_y) * 2 * Math::PI
      x = Math.sin(radius_x) * CAMERA_DISTANCE
      y = Math.sin(radius_y) * CAMERA_DISTANCE
      z_square = CAMERA_DISTANCE**2 - x**2 - y**2
      z = z_square < 0 ? -Math.sqrt(-z_square) : Math.sqrt(z_square)
      set_camera x, y, z
    end

    def set_camera x, y, z
      @camera.position.x = x
      @camera.position.y = y
      @camera.position.z = z
      @camera.look_at Mittsu::Vector3.new(0,0,0)
    end
  end
end
