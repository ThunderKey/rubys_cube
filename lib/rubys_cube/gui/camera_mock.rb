require_relative 'camera'

class RubysCube
  class Gui
    class CameraMock < Camera
      def to_mittsu_camera
        @real_camera
      end

      def setup renderer, scene
        puts 'mock'
        super
        @real_camera = @camera
        @camera = Mittsu::Mesh.new(
          Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
          ColorScheme.default.to_mesh_face_material
        )
        rotate 0, 0
        scene.add(@camera)

        @real_camera.position.x = 10
        @real_camera.position.y = 10
        @real_camera.position.z = 10
        @real_camera.look_at Mittsu::Vector3.new(0,0,0)
      end
    end
  end
end
