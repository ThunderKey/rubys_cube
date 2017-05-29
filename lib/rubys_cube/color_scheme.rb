class ColorScheme
  def self.default
    new(
      front:  0x0046AD, # blue
      back:   0x009B48, # green
      top:    0xFFFFFF, # white
      bottom: 0xFFD500, # yellow
      right:  0xF55500, # orange
      left:   0xB71234, # red
    )
  end

  attr_reader :front, :back, :top, :bottom, :left, :right

  def initialize front:, back:, top:, bottom:, left:, right:
    @front  = front
    @back   = back
    @top    = top
    @bottom = bottom
    @left   = left
    @right  = right
  end

  def to_mesh_face_material
    Mittsu::MeshFaceMaterial.new [
      right, left,
      top, bottom,
      front, back,
    ].map {|c| Mittsu::MeshBasicMaterial.new(color: c) }
  end
end
