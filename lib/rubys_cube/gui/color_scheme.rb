module RubysCube
  class Gui
    class ColorScheme
      def self.default
        new(
          Orientation.front.key  => 0x0046AD, # blue
          Orientation.back.key   => 0x009B48, # green
          Orientation.top.key    => 0xFFFFFF, # white
          Orientation.bottom.key => 0xFFD500, # yellow
          Orientation.right.key  => 0xF55500, # orange
          Orientation.left.key   => 0xB71234, # red
        )
      end

      attr_reader :color_mapping

      def initialize color_mapping
        @color_mapping = color_mapping
        unless @color_mapping.size == Orientation.orientation_names.size && Orientation.orientation_names.all? {|o| @color_mapping.keys.include? o }
          raise "The color_mapping need to map the following orientations: #{Orientation.orientation_names.join ', '}"
        end
      end

      def [] orientation
        if orientation.is_a? Orientation
          orientation = orientation.key
        end
        raise "unknown orientation #{orientation.inspect}" unless @color_mapping.has_key? orientation
        @color_mapping[orientation]
      end

      def to_mesh_face_material
        Mittsu::MeshFaceMaterial.new [
          :right, :left,
          :top, :bottom,
          :front, :back,
        ].map { |c| Mittsu::MeshBasicMaterial.new(color: self[c]) }
      end
    end
  end
end
