tool
extends Spatial

export (String, MULTILINE) var displayed_text setget set_displayed_text


func _ready():
	set_displayed_text(displayed_text)
	find_node("Viewport").render_target_update_mode = (
		Viewport.UPDATE_ALWAYS
		if Engine.editor_hint
		else Viewport.UPDATE_ONCE
	)


func set_displayed_text(value: String) -> void:
	displayed_text = value
	if name:
		find_node("Label").text = displayed_text
		find_node("Viewport").render_target_update_mode = Viewport.UPDATE_ONCE
