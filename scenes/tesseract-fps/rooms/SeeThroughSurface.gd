tool
extends CSGMesh

export (bool) var _update_material setget set_update_material

var _player_node = null


func setup_material():
	var shader_mat: ShaderMaterial = material
	shader_mat.set_shader_param("vp_texture", $Viewport.get_texture())
	yield(get_tree(), "idle_frame")
	shader_mat.set_shader_param("vp_texture", $Viewport.get_texture())
	yield(get_tree(), "idle_frame")
	shader_mat.set_shader_param("vp_texture", $Viewport.get_texture())


func set_update_material(_value):
	if material && material.has_method("set_shader_param"):
		setup_material()


func _ready():
	setup_material()


func _physics_process(_delta):
	if Engine.editor_hint:
		return

	if not _player_node:
		_player_node = get_tree().current_scene.find_node("Player")
	if not _player_node:
		return

	var cam = _player_node.find_node("Camera")
	if not cam:
		return
	$Viewport/OutsideScene.set_camera_transform(cam.global_transform)
