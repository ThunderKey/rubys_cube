module RubysCube
  class Orientation
    def self.orientations
      @orientations.values
    end

    def self.orientation_names
      @orientations.keys
    end

    attr_reader :key

    def initialize key, x: nil, y: nil, z: nil
      @key = key
      set_values = [x, y, z].reject &:nil?
      raise 'only one of x, y and z may be set' if set_values.size > 1
      raise 'one of x, y and z must be set' if set_values.empty?
      raise 'The value of x, y or z must be either -1 or 1' unless [-1, 1].include? set_values[0]
      @x = x
      @y = y
      @z = z
    end

    @orientations = {
      right:  new(:right,  x:  1),
      left:   new(:left,   x: -1),
      top:    new(:top,    y:  1),
      bottom: new(:bottom, y: -1),
      front:  new(:front,  z:  1),
      back:   new(:back,   z: -1),
    }

    @orientations.each do |key, orientation|
      define_singleton_method(key) { orientation }
    end
  end
end