extends KinematicBody2D

const SPEED := 250.0
const GRAVITY := 150.0
const FRICTION := 50.0

var v := Vector2()


func _physics_process(delta: float):
	# horizontal movement
	var h_input := (
		int(Input.is_action_pressed("move_right"))
		- int(Input.is_action_pressed("move_left"))
	)
	if h_input != 0:
		var acc := h_input * delta * SPEED
		v += acc * Vector2.RIGHT.rotated(rotation)
	# gravity
	v += delta * GRAVITY * Vector2.DOWN.rotated(rotation)
	# jump
	if Input.is_action_just_pressed("move_up") || Input.is_action_just_pressed("movement_jump"):
		# jump
		if is_on_floor():
			v.y = -150.0
	# update physics
	v = move_and_slide(v, Vector2.UP.rotated(rotation))
	# horizontal friction
	v.x = sign(v.x) * max(0, abs(v.x) - delta * FRICTION)
