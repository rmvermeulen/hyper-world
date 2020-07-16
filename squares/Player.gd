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


func _unjump():
	_jumping = false


func _on_Player_body_entered(body):
	if _jumping:
		return
	var current_room = body.get_parent()
	var side = body.name
	prints(current_room.name, side)
	var target = null
	for c in get_parent().connectors:
		if c.a == current_room && Connector2D.connection_name(c.connection_a) == side:
			target = c.b.get_node(Connector2D.connection_name(c.connection_b))
		if c.b == current_room && Connector2D.connection_name(c.connection_b) == side:
			target = c.a.get_node(Connector2D.connection_name(c.connection_a))
			break
	assert(target)
	prints(target.get_path())
	_jumping = true
	global_position = target.global_position
	$Tween.stop_all()
	$Tween.interpolate_callback(self, 0.1, "_unjump")
	$Tween.start()


func _on_Player_body_exited(body):
	prints("exited", body.get_path())
