extends Spatial

export (int, LAYERS_3D_RENDER) var _room_layer setget set_render_layers


func set_render_layers(value: int) -> void:
	_room_layer = value
	_set_render_layers_recursively(self)


# find the highest VisualInstance(s) and set the render layers
func _set_render_layers_recursively(node: Spatial) -> void:
	if node is VisualInstance:
		node.layers = _room_layer
		return
	for child in node.get_children():
		_set_render_layers_recursively(child)
