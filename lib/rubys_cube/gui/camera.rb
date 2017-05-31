module RubysCube
  class Gui
    class Camera
      attr_reader :width, :height

      def initialize width: 800, height: 600, camera_distance: 5
        @camera_distance = camera_distance.to_f
        @width = width.to_f
        @height = height.to_f
      end

      def to_mittsu_camera
        @camera
      end

      def screen_width renderer
        renderer.window.instance_variable_get(:@width)
      end

      def screen_height renderer
        renderer.window.instance_variable_get(:@height)
      end

      def setup renderer, scene
        @camera = Mittsu::PerspectiveCamera.new(75.0, screen_width(renderer) / screen_height(renderer), 0.1, 1000.0)
        rotate 0.2, 0.2
        @camera.look_at Mittsu::Vector3.new(0, 0, 0)

        position_start = nil
        renderer.window.on_mouse_button_pressed do |_button, position|
          position_start = position
        end
        renderer.window.on_mouse_button_released do |_button, _position|
          position_start = nil
        end
        renderer.window.on_mouse_move do |position|
          if position_start
            rotate(
              2 * (position_start.x - position.x) / screen_width(renderer),
              2 * (position_start.y - position.y) / screen_height(renderer),
            )
            position_start = position
          end
        end
      end

      # 1 = 360 degrees
      def rotate move_x, move_y
        current_radian_x = Math.acos(@camera.position.x / @camera_distance)
        current_radian_y = Math.acos(@camera.position.y / @camera_distance)
        if @camera.position.z < 0
          current_radian_x = (2 * Math::PI) - current_radian_x
          current_radian_y = (2 * Math::PI) - current_radian_y
        end
        radian_x = current_radian_x - move_x * 2 * Math::PI
        radian_y = current_radian_y - move_y * 2 * Math::PI
        x = Math.cos(radian_x) * @camera_distance
        y = Math.cos(radian_y) * @camera_distance
        z = Math.sqrt (@camera_distance**2 - x**2 - y**2).abs
        z *= -1 if (radian_x.abs % (2 * Math::PI)) > Math::PI || (radian_y.abs % (2 * Math::PI)) > Math::PI
        @camera.position.x = x
        @camera.position.y = y
        @camera.position.z = z
        horizontal_rotation = Math::PI / 2 - radian_x
        @camera.rotation.y = horizontal_rotation
        @camera.rotation.z = -radian_y
      end
    end
  end
end
