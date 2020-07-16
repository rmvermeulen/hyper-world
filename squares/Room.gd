extends Node2D

export (Vector2) var size := Vector2(128, 128) setget set_size
export (NodePath) var north
export (NodePath) var south
export (NodePath) var east
export (NodePath) var west


func _ready():
	_update_colliders()


#	prints(name, 'ready', get_child_count())


func set_size(value: Vector2) -> void:
	size = Vector2(floor(value.x), floor(value.y))
	_update_colliders()


func _update_colliders():
	if not name:
		return
	_ensure_node("North")
	_ensure_node("South")
	_ensure_node("East")
	_ensure_node("West")

	var hs = size * .5
	$North/Shape.shape.extents = Vector2(hs.x, 10)
	$North.position = hs * Vector2(0, -1)
	$South/Shape.shape.extents = Vector2(hs.x, 10)
	$South.position = hs * Vector2(0, 1)
	$East/Shape.shape.extents = Vector2(10, hs.y)
	$East.position = hs * Vector2(1, 0)
	$West/Shape.shape.extents = Vector2(10, hs.y)
	$West.position = hs * Vector2(-1, 0)

	update()


func _ensure_node(named: String) -> void:
	if not name:
		return
	if get_node_or_null(named):
		return

	var rect = RectangleShape2D.new()
	rect.extents = size
	var shape = CollisionShape2D.new()
	shape.shape = rect
	shape.name = "Shape"

	var body = StaticBody2D.new()
	body.name = named

	body.add_child(shape)
	add_child(body)
	if Engine.editor_hint:
		var o = get_tree().edited_scene_root
		shape.owner = o
		body.owner = o


func _draw() -> void:
	draw_rect(Rect2(size * -.5, size), Color.black, false)

# end
