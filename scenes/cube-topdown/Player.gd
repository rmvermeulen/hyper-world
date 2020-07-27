extends KinematicBody2D

const SPEED := 250.0


func _physics_process(_delta):
	var input = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	)
	var velocity = SPEED * input.rotated(rotation).normalized()
	move_and_slide(velocity)
