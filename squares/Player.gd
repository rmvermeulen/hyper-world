extends KinematicBody2D


func _physics_process(_delta):
	var input = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	)
	move_and_slide(input.normalized().rotated(rotation) * 100)
