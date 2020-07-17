extends Area2D

var _jumping := false


func _ready():
	pass


func _physics_process(delta):
	var input = Vector2(
		int(Input.is_key_pressed(KEY_RIGHT)) - int(Input.is_key_pressed(KEY_LEFT)),
		int(Input.is_key_pressed(KEY_DOWN)) - int(Input.is_key_pressed(KEY_UP))
	)
	position += delta * (input.normalized() * 100)


func _on_Player_body_entered(body):
	if _jumping:
		return
	var current_room = body.get_parent()
	var side = body.name
	prints(current_room.name, side)
	var target = null
	var angle = null
	for c in get_parent().connectors:
		if c.a == current_room && Connector2D.connection_name(c.connection_a) == side:
			target = c.b.get_node(Connector2D.connection_name(c.connection_b))
			angle = c.a_to_b.get_rotation()
			break
		if c.b == current_room && Connector2D.connection_name(c.connection_b) == side:
			target = c.a.get_node(Connector2D.connection_name(c.connection_a))
			angle = -1 * c.a_to_b.get_rotation()
			break
	assert(target)
	prints(target.get_path())
	_jumping = true
	global_position = target.global_position
	rotate(angle)
	$TransitionTimer.start()


func _on_Player_body_exited(body):
	prints("exited", body.get_path())


func _on_TransitionTimer_timeout():
	_jumping = false
