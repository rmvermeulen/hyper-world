extends Spatial

signal changed_room(new_room)

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
		if not child.is_connected("body_entered", self, "_on_body_entered"):
			assert(OK == child.connect("body_entered", self, "_on_body_entered", args))
		if not child.is_connected("body_exited", self, "_on_body_exited"):
			assert(OK == child.connect("body_exited", self, "_on_body_exited", args))


func _check_state():
	var count = 0
	for v in states.values():
		count += 1 if v else 0
	if count == 1:
		for k in states.keys():
			if not states[k] || current_room == k:
				continue
			current_room = k
			emit_signal("changed_room", current_room)
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
