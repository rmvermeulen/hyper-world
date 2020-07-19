extends Node2D

# const FLOOR_TEXTURE := preload("res://assets/proto-textures/Dark/texture_05.png")
const ROOM_SIZE := 256

var current_room_id := "front"

var planes = {
	"front":
	{
		"north": "top/south",
		"south": "bottom/north",
		"east": "right/west",
		"west": "left/east",
	},
	"back":
	{
		"north": "top/north",
		"south": "bottom/south",
		"east": "left/west",
		"west": "right/east",
	},
	"left":
	{
		"north": "top/west",
		"south": "bottom/east",
		"east": "front/west",
		"west": "back/east",
	},
	"right":
	{
		"north": "top/east",
		"south": "bottom/west",
		"east": "back/west",
		"west": "front/east",
	},
	"top":
	{
		"north": "back/north",
		"south": "front/north",
		"east": "right/north",
		"west": "left/north",
	},
	"bottom":
	{
		"north": "front/south",
		"south": "back/south",
		"east": "right/south",
		"west": "left/south",
	},
}


func _ready():
	_change_room_to(current_room_id)
	for wall in $RoomArea/Walls.get_children():
		assert(
			(
				OK
				== (wall as Area2D).connect(
					"body_entered", self, "_on_wall_body", [wall.name.to_lower()]
				)
			)
		)


func _change_room_to(room: String) -> void:
	var info = planes[room]
	# update labels
	$RoomArea/Labels/Current.text = room
	$RoomArea/Labels/North.text = info.north.split("/")[0]
	$RoomArea/Labels/East.text = info.east.split("/")[0]
	$RoomArea/Labels/South.text = info.south.split("/")[0]
	$RoomArea/Labels/West.text = info.west.split("/")[0]

	# change texture rotation
	# todo

	# change preview textures
	var pvs = $RoomArea/Previews
	for pv in pvs.get_children():
		var from = pv.name.to_lower()
		var to = info[from].split("/")[1]
		var r = _get_preview_rotation(from, to)
		pv.rotation = r
		prints(from, to, 'set rotation', r)

	# redraw
	update()


func _get_preview_rotation(from: String, to: String) -> float:
	var r = _get_rotation(from) + _get_rotation(to)
	return wrapf(r, 0, TAU)


func _get_rotation(wd: String) -> float:
	match wd:
		"north":
			return 0.0
		"east":
			return PI
		"south":
			return TAU
		"west":
			return -PI
	assert(false)
	return 0.0


func _on_Player_body_entered(body):
	var room = planes[current_room_id]
	prints(current_room_id, '->', room[body.name.to_lower()])


func _on_wall_body(body: KinematicBody2D, tag: String):
	if not body:
		return
	var offset = Vector2()
	match tag:
		"north":
			offset.y = ROOM_SIZE
		"east":
			offset.x = -ROOM_SIZE
		"south":
			offset.y = -ROOM_SIZE
		"west":
			offset.x = ROOM_SIZE
	body.position += offset
	var next_room = planes[current_room_id][tag].split("/")[0]
	_change_room_to(next_room)

# end
