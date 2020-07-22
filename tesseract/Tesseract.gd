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
			Vector4.from_fields(segment[0]),
			Vector4.from_fields(segment[1]),
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
	var x: float setget , get_x
	var y: float setget , get_y
	var z: float setget , get_z
	var w: float setget , get_w
	var _fields := []

	func get_x():
		return _fields[0]

	func get_y():
		return _fields[1]

	func get_z():
		return _fields[2]

	func get_w():
		return _fields[3]

	func _init(x: float, y: float, z: float, w: float):
		_fields = [x, y, z, w]

	func length_squared() -> float:
		var squares := 0.0
		for i in 4:
			squares += _fields[i] * _fields[i]
		return squares

	func length() -> float:
		return sqrt(length_squared())

	func project() -> Vector3:
		return Vector3(get_x(), get_y(), get_z()) * length()

	func rotated(amount: float) -> Vector4:
		var v := Vector4.from_fields(_fields)
		v.x *= cos(amount)
		v.y *= sin(amount)
		return v

	func _to_string():
		return "Vector4(%.2f, %.2f, %.2f, %.2f)" % _fields

	static func from_fields(v4: Array) -> Vector4:
		assert(v4.size() >= 4)
		return Vector4.new(v4[0], v4[1], v4[2], v4[3])
