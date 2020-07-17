extends Node


func _ready():
	for i in range(3, 8):
		prints(Quboid.new(i))


class Quboid:
	var n: int setget set_n
	var vertices: Array setget set_v

	func _init(dim = 0):
		n = dim
		vertices = generate_vertices(n)

	func set_n(_n):
		pass

	func set_v(_v):
		pass

	func _to_string():
		return "[Quboid(%d, %s) %s]" % [n, vertices.size(), vertices]

	static func generate_vertices(dim_count = 0) -> Array:
		if dim_count == 0:
			return []

		var dimensions = []
		for i in dim_count:
			dimensions.push_front(i + 1)

		var vertices := []
		while true:
			var index := vertices.size()

			var permutation = []
			for d in dimensions:
				if dim_count >= d:
					permutation.append((index / d) % 2)

			if vertices.has(permutation):
				break

			vertices.append(permutation)

		return vertices
