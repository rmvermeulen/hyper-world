extends Node2D

# const FLOOR_TEXTURE := preload("res://assets/proto-textures/Dark/texture_05.png")
const ROOM_SIZE := 512

var _cube_data = preload("res://resources/cube/data.gd").create()
var _current_room_id := "front"
var _player_room_jump_timeout := 0.0

onready var slot_current := $RoomArea/Slots/Current
onready var slot_invisible := $RoomArea/Slots/Invisible
onready var slot_north := $RoomArea/Slots/North
onready var slot_east := $RoomArea/Slots/East
onready var slot_south := $RoomArea/Slots/South
onready var slot_west := $RoomArea/Slots/West

onready var room_front := slot_current.get_child(0)
onready var room_back := slot_invisible.get_child(0)
onready var room_left := slot_west.get_child(0)
onready var room_right := slot_east.get_child(0)
onready var room_top := slot_north.get_child(0)
onready var room_bottom := slot_south.get_child(0)

onready var rooms := [
	room_front,
	room_back,
	room_left,
	room_right,
	room_top,
	room_bottom,
]


func _ready():
	assert(slot_current)
	assert(slot_invisible)
	assert(slot_north)
	assert(slot_south)
	assert(slot_east)
	assert(slot_west)

	for node in rooms:
		assert(node)

	_change_room_to(_current_room_id, "north")
	for wall in $RoomArea/Walls.get_children():
		var area: Area2D = wall
		var key = area.name.to_lower()
		assert(OK == area.connect("body_entered", self, "_on_wall_body", [key]))


func _process(delta):
	_player_room_jump_timeout = max(0, _player_room_jump_timeout - delta)


func _change_room_to(next_room_id: String, dir: String) -> void:
	prints('changing room (from %s):' % dir, next_room_id)
	# rotate the player and camera
	var player_rot: float = _cube_data[_current_room_id][dir].angle
	prints('player rot', rad2deg(player_rot))
	$RoomArea.rotation -= player_rot

	var info = _cube_data[next_room_id]
	# unparent rooms to move them around
	for room in rooms:
		_unparent(room)
	# set preview rooms
	for wdir in ["north", "south", "east", "west"]:
		var connection = info[wdir]
		var slot = _get_slot(wdir)
		# set slot rotation relative to current room
		slot.rotation = -connection.angle
		# add room as child
		slot.add_child(_get_room(connection.id))

	# set current room
	slot_current.add_child(_get_room(next_room_id))

	# move the rest of the nodes out of view
	for room in rooms:
		if room.get_parent():
			continue
		slot_invisible.add_child(room)

	# and we're done
	_current_room_id = next_room_id


func _get_room(id: String):
	return get("room_%s" % id)


func _get_slot(dir: String):
	return get("slot_%s" % dir)


static func _unparent(node):
	var p = node.get_parent()
	if p:
		p.remove_child(node)


func _on_Player_body_entered(body):
	var room = _cube_data[_current_room_id]
	prints(_current_room_id, '->', room[body.name.to_lower()])


func _on_wall_body(body: KinematicBody2D, wall_tag: String):
	if not body:
		return
	if _player_room_jump_timeout > 0:
		return
	_player_room_jump_timeout = 0.1
	# find out where to move the player
	var offset = Vector2()
	match wall_tag:
		"north":
			offset.y = ROOM_SIZE
		"east":
			offset.x = -ROOM_SIZE
		"south":
			offset.y = -ROOM_SIZE
		"west":
			offset.x = ROOM_SIZE
	body.position += offset.rotated($RoomArea.rotation)

	var next_room = _cube_data[_current_room_id][wall_tag].id
	_change_room_to(next_room, wall_tag)

# end
