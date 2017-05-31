require 'mittsu'
require_relative 'color_scheme'
require_relative 'gui/dispatcher'
require_relative 'gui/camera'

class RubysCube
  class Gui
    attr_reader :dispatcher

    def initialize cube, color_scheme: nil, spacing: nil, camera: nil
      @cube = cube
      @color_scheme = color_scheme || ColorScheme.default
      @spacing = spacing || 0.1
      @dispatcher = Dispatcher.new
      @camera = camera || Camera.new
    end

    def start
      @renderer = Mittsu::OpenGLRenderer.new width: @camera.width, height: @camera.height, title: %q{Ruby's Cube}

      @scene = Mittsu::Scene.new

      @camera.setup @renderer, @scene
      setup_cube
      setup_room
      setup_light

      @renderer.window.run do
        @renderer.render(@scene, @camera.to_mittsu_camera)

        @dispatcher.execute self
      end
    end

    private

    def setup_cube
      @boxes = Array.new(3) { Array.new(3) { Array.new 3 } }
      faces = @color_scheme.to_mesh_face_material
      (0..2).to_a.repeated_permutation(3).each do |x,y,z|
        box = Mittsu::Mesh.new(
          Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
          faces
        )
        box.position.x = x - 1 + (x-1) * @spacing
        box.position.y = y - 1 + (y-1) * @spacing
        box.position.z = z - 1 + (z-1) * @spacing
        @boxes[x][y][z] = box
        @scene.add box
      end
    end

    def setup_room
      room_material = Mittsu::MeshPhongMaterial.new(color: 0xFFFFFF)
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
