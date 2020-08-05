tool
class_name Rotator
extends Spatial

export (bool) var cycle_next := false setget _next
export (bool) var cycle_prev := false setget _prev
export (float) var spacing := 0.0 setget _set_spacing


func _ready():
	_set_spacing(spacing)


func _set_spacing(value: float):
	spacing = value
	for i in get_child_count():
		var child: Spatial = get_child(i)
		var p := child.transform.origin
		p.x = 0 if p.x == 0 else p.x + spacing * i * sign(p.x)
		p.y = 0 if p.y == 0 else p.y + spacing * i * sign(p.y)
		p.z = 0 if p.z == 0 else p.z + spacing * i * sign(p.z)
		child.transform.origin = p


func _next(_value: bool):
	_cycle(1)


func _prev(_value: bool):
	_cycle(-1)


func _cycle(amount: int):
	var kids := get_children()
	var pos := []
	for kid in kids:
		pos.append(kid.transform.origin)
	var new_pos := _offset(pos, amount)
	for i in kids.size():
		kids[i].transform.origin = new_pos[i]


static func _offset(items: Array, amount: int) -> Array:
	var result := items.duplicate()
	var step := sign(amount)
	for i in abs(amount):
		if step > 0:
			result.push_front(result.pop_back())
		else:
			result.push_back(result.pop_front())
	return result
