extends Node


func _ready():
#	for i in range(3, 8):
	for i in range(2, 6):
		var q = Quboid.new(i)
		prints(q)
		var lines = q.get_lines()
		prints('\tlines', lines.size())
		for line in lines:
			prints('\t\t', line)

		var planes = q.get_planes()
		prints('\tplanes', planes.size())
		for plane in planes:
			prints('\t\t', plane)

		var volumes = q.get_volumes()
		prints('\tvolumes', volumes.size())
		for volume in volumes:
			prints('\t\t', volume)


class Quboid:
	var n: int setget set_n
	var vertices: Array setget set_v

	func _init(dim = 1):
		n = dim
		vertices = _generate_vertices(n)

	func set_n(_n):
		pass

	func set_v(_v):
		pass

	func get_lines() -> Array:
		var lines := []
		for li in self.n:
			# find lines in dimension n
			var results := []
			for vi in vertices.size():
				var a: Array = vertices[vi]
				for vj in range(vi + 1, vertices.size()):
					var b: Array = vertices[vj]
					var ok = true
					for i in a.size():
						if not ok:
							break
						var eq: bool = a[i] == b[i]
						ok = ok && (! eq if i == li else eq)
					if ok:
						results.append([a, b])

			for line in results:
				lines.append(line)
		return lines

	func get_planes() -> Array:
		var planes := []
		if n < 2:
			return []
		if n == 2:
			return [vertices]
		# find planes n>2
		for i in n:
			# group by nth value
			var groups := {}
			for v in vertices:
				var key = v[i]
				var group: Array = groups[key] if groups.has(key) else []
				group.append(v)
				groups[key] = group
			# each group is a plane
			for group in groups.values():
				if group.size() == 4:
					planes.append(group)
		return planes

	func get_volumes() -> Array:
		return []

	func _to_string():
#		return "[Quboid(%d, %s) %s]" % [n, vertices.size(), vertices]
		return "[Quboid(%d, %s)]" % [n, vertices.size()]

	static func _generate_vertices(dim_count = 1) -> Array:
		if dim_count <= 1:
			return [[0], [1]]
		var vertices := []
		var subd := _generate_vertices(dim_count - 1)
		for vertex in subd:
			var copy: Array = vertex.duplicate()
			vertex.push_front(0)
			vertices.append(vertex)
			copy.push_front(1)
			vertices.append(copy)

		return vertices
