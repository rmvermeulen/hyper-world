extends KinematicBody2D

var _jumping := false


func _ready():
	pass


func _physics_process(_delta):
	var input = Vector2(
		int(Input.is_key_pressed(KEY_RIGHT)) - int(Input.is_key_pressed(KEY_LEFT)),
		int(Input.is_key_pressed(KEY_DOWN)) - int(Input.is_key_pressed(KEY_UP))
	)
	move_and_slide(input.normalized() * 100)


func _on_TransitionTimer_timeout():
	_jumping = false
