extends ImmediateGeometry

const Dimensionator = preload("res://testing_b/Dimensionator.gd")

var segments := []
var _display_angle := 0.0


func _ready():
	var q = Dimensionator.Quboid.new(4)
	segments = q.get_lines()
	# center coordinates
	for segment_index in segments.size():
		var segment = segments[segment_index]
		for point in segment:
			for ci in point.size():
				var coordinate: float = point[ci]
				point[ci] = 0.5 if coordinate > 0 else -0.5
		segments[segment_index] = [
			Vector4.callv("new", segment[0]),
			Vector4.callv("new", segment[1]),
		]


func _process(delta):
	# move the center of the projection around
	_display_angle = wrapf(_display_angle + (delta * PI * 0.25), -TAU, TAU)
	var center = 1.0 * Vector3.LEFT.rotated(Vector3.FORWARD, _display_angle)

	# re-setup the 3d mesh
	clear()
	begin(Mesh.PRIMITIVE_LINES)

	# add each line segment
	for segment in segments:
		add_vertex(center + segment[0].project())
		add_vertex(center + segment[1].project())
	# done
	end()


class Vector4:
	var x: float
	var y: float
	var z: float
	var w: float

	func _init(x: float, y: float, z: float, w: float):
		self.x = x
		self.y = y
		self.z = z
		self.w = w

	func length_squared() -> float:
		return x * x + y * y + z * z + w * w

	func length() -> float:
		return sqrt(length_squared())

	func project() -> Vector3:
		return Vector3(x, y, z) * ((1.0 - (w)) + length())

	func rotated(amount: float) -> Vector4:
		var v := duplicate()
		v.x *= cos(amount)
		v.y *= sin(amount)
		return v

	func _to_string():
		return "Vector4(%.2f, %.2f, %.2f, %.2f)" % [x, y, z, w]

	func duplicate() -> Vector4:
		return Vector4.new(x, y, z, w)
