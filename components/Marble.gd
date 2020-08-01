extends RigidBody2D


func _ready():
	linear_velocity = 50.0 * Vector2.DOWN.rotated(randf() * TAU)


func _physics_process(_delta):
	var rect := get_viewport_rect()
	var top_left := rect.position
	var bottom_right := rect.end

	position.y = wrapf(position.y, top_left.y, bottom_right.y)
