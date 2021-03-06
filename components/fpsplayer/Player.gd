extends KinematicBody

const GRAVITY = -32.8
const MAX_SPEED = 10
const JUMP_SPEED = 12
const ACCEL = 4.5
const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40
const MOUSE_SENSITIVITY = 0.05
const MAX_SPRINT_SPEED = 20
const SPRINT_ACCEL = 18

var global = "root/global"

var vel = Vector3()
var dir = Vector3()

var camera
var rotation_helper

var is_sprinting = false

var flashlight


func _ready():
	camera = $rotation_helper/Camera
	rotation_helper = $rotation_helper
	flashlight = $rotation_helper/Flashlight

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	_process_input(delta)
	_process_movement(delta)

	if Input.is_key_pressed(KEY_Y):
		assert(OK == get_tree().reload_current_scene())


func _process_input(delta):
	# todo: remove, or integrate properly
	var cam_input = Vector2()
	if Input.is_action_pressed("ui_up"):
		cam_input.y -= 1
	if Input.is_action_pressed("ui_down"):
		cam_input.y += 1
	if Input.is_action_pressed("ui_left"):
		cam_input.x -= 1
	if Input.is_action_pressed("ui_right"):
		cam_input.x += 1
	if cam_input.length_squared() > 0:
		_camera_rotation_input(delta * cam_input * 250)
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
	dir += cam_xform.basis.x.normalized() * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

# ----------------------------------
# Turning the flashlight on/off
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.is_visible_in_tree():
			flashlight.hide()
		else:
			flashlight.show()


# ----------------------------------


func _process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_camera_rotation_input(event.relative * MOUSE_SENSITIVITY)
	if event is InputEventJoypadMotion:
		match event.axis:
			# movement
			JOY_AXIS_0:
				pass
			JOY_AXIS_1:
				pass
			# look around
			JOY_AXIS_2:
				_camera_rotation_input((Vector2.RIGHT * event.axis_value) / MOUSE_SENSITIVITY)
			JOY_AXIS_3:
				_camera_rotation_input((Vector2.UP * event.axis_value) / MOUSE_SENSITIVITY)


func _camera_rotation_input(move: Vector2) -> void:
	rotation_helper.rotate_x(deg2rad(move.y))
	self.rotate_y(deg2rad(move.x * -1))

	var camera_rot = rotation_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, -80, 80)
	rotation_helper.rotation_degrees = camera_rot
