extends Node2D

var connectors = []


func _ready():
	connectors = []
	for c in get_children():
		if c is Connector2D:
			connectors.append(c)


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
