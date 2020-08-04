tool
extends Spatial

export (String, MULTILINE) var displayed_text setget set_displayed_text

var _player_node: Spatial = null


func _ready():
	set_displayed_text(displayed_text)
	find_node("Viewport").render_target_update_mode = (
		Viewport.UPDATE_ALWAYS
		if Engine.editor_hint
		else Viewport.UPDATE_ONCE
	)


func set_displayed_text(value: String) -> void:
	displayed_text = tr(value.strip_edges())
	if name:
		find_node("Label").text = displayed_text
		find_node("Viewport").render_target_update_mode = Viewport.UPDATE_ONCE


func _physics_process(delta) -> void:
	if Engine.editor_hint:
		return

	if not _player_node:
		_player_node = _get_player()
	if not _player_node:
		return

	var my_pos := global_transform.origin
	var p_pos := _player_node.global_transform.origin
	if my_pos.distance_squared_to(p_pos) > 80:
		return

	var target_dir := (
		(-0.5 * PI)
		- Vector2(my_pos.x, my_pos.z).angle_to_point(Vector2(p_pos.x, p_pos.z))
	)
	var step := wrapf(target_dir - rotation.y, -PI, PI)
	rotation.y += step * delta


func _get_player() -> Spatial:
	return get_tree().current_scene.find_node("Player") as Spatial
