extends Spatial

signal player_changed_room(old_room, new_room)

var current_room := "inner"
var states := {
	"inner": false,
	"front": false,
	"back": false,
}


func _ready():
	var amount := 0
	for child in get_children():
		if not (child is Area):
			continue
		var args = [child.name.to_lower()]
		_link(child, "body_entered", args)
		_link(child, "body_exited", args)


func _link(node: Node, action: String, args: Array):
	var fn := "_on_%s" % action
	if not node.is_connected(action, self, fn):
		assert(OK == node.connect(action, self, fn, args))


func _check_state():
	var count = 0
	for v in states.values():
		count += 1 if v else 0
	if count == 1:
		for k in states.keys():
			if not states[k] || current_room == k:
				continue
			emit_signal("player_changed_room", current_room, k)
			current_room = k
			break


func _on_body_entered(body: KinematicBody, tag: String) -> void:
	if not body || body.name != "Player":
		return
	states[tag] = true
	_check_state()


func _on_body_exited(body: KinematicBody, tag: String) -> void:
	if not body || body.name != "Player":
		return
	states[tag] = false
	_check_state()

# end
