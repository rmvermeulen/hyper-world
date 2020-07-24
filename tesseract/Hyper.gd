class_name Hyper
extends Reference


class V4:
	extends Reference
	static func x(v4: Array) -> float:
		return v4[0]
	static func y(v4: Array) -> float:
		return v4[1]
	static func z(v4: Array) -> float:
		return v4[2]
	static func w(v4: Array) -> float:
		return v4[3]

	static func length_squared(v4: Array) -> float:
		var total := 0.0
		for i in 4:
			total += (v4[i] * v4[i])
		return total

	static func length() -> float:
		return sqrt(length_squared())

	static func project(v4: Array) -> Vector3:
		return Vector3(x(v4), y(v4), z(v4)) * ((1.0 - (w(v4))) + length())

	# static func rotated(v4: Array, amount: float) -> Array:
	# 	var v := v4.duplicate()
	# 	# todo
	# 	return v

	static func _to_string():
		return "Vector4(%.2f, %.2f, %.2f, %.2f)" % [x, y, z, w]