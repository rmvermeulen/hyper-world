extends ImmediateGeometry

const Dimensionator = preload("res://testing_b/Dimensionator.gd")

var segments := []
var _display_angle := 0.0


func _ready():
	var q = Dimensionator.Quboid.new(4)
	segments = q.get_lines()
	# center coordinates
	for segment in segments:
		for point in segment:
			for ci in point.size():
				var coordinate: float = point[ci]
				point[ci] = 0.5 if coordinate > 0 else -0.5


func _process(delta):
	# move the center of the projection around
	_display_angle = wrapf(_display_angle + (delta * PI * 0.25), -TAU, TAU)
	var center = 1.0 * Vector3.LEFT.rotated(Vector3.FORWARD, _display_angle)

	# re-setup the 3d mesh
	clear()
	begin(Mesh.PRIMITIVE_LINES)

	# add each line segment
	for segment in segments:
		add_vertex(center + _project(segment[0]))
		add_vertex(center + _project(segment[1]))

	# done
	end()


func _project(v4: Array) -> Vector3:
	return Vector3(v4[0], v4[1], v4[2])
