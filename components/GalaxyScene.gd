extends Spatial

var camera_transform: Transform setget set_camera_transform


func set_camera_transform(value: Transform) -> void:
	camera_transform = value.rotated(Vector3.UP, PI * 0.5)
	$Camera.transform = camera_transform
