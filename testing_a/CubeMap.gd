extends Node2D

var connectors = []


func _ready():
	connectors = []
	for c in get_children():
		if c is Connector2D:
			connectors.append(c)
	var re = RegEx.new()
	re.compile("\\d(\\w)")
	for c in connectors:
		var ms = re.search_all(c.name)
		assert(ms.size() == 2)
		var ta = ms[0].get_string(1)
		var tb = ms[1].get_string(1)
		var t = Transform2D()
		if ta != tb:
			match ta:
				'N':
					match tb:
						'E':
							t = t.rotated(deg2rad(90))
						'S':
							t = t.rotated(deg2rad(180))
						'W':
							t = t.rotated(deg2rad(-90))
				'E':
					match tb:
						'S':
							t = t.rotated(deg2rad(90))
						'W':
							t = t.rotated(deg2rad(180))
						'N':
							t = t.rotated(deg2rad(-90))
				'S':
					match tb:
						'W':
							t = t.rotated(deg2rad(90))
						'N':
							t = t.rotated(deg2rad(180))
						'E':
							t = t.rotated(deg2rad(-90))
				'W':
					match tb:
						'N':
							t = t.rotated(deg2rad(90))
						'E':
							t = t.rotated(deg2rad(180))
						'S':
							t = t.rotated(deg2rad(-90))
		# assign rotated transform to connector
		c.a_to_b = t


func _process(_delta):
	update()


func _draw():
	for c in connectors:
		var an = c.a.get_node_or_null(Connector2D.connection_name(c.connection_a))
		var bn = c.b.get_node_or_null(Connector2D.connection_name(c.connection_b))
		assert(c.a.get_child_count() == 4)
		assert(c.b.get_child_count() == 4)
		if not (an && bn):
			continue
		var a = to_local(an.global_position) + 3 * _rv()
		var b = to_local(bn.global_position) + 3 * _rv()
#		prints([a, b])
		draw_line(a, b, Color.red)


func _rv() -> Vector2:
	return Vector2((randf() * 2.0) - 1.0, (randf() * 2.0) - 1.0)
