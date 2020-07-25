extends Spatial

const ROOM_SIZE := 20

const SLOT_INNER := Vector3() * ROOM_SIZE
const SLOT_OUTER := Vector3(10, 0, 0) * ROOM_SIZE
const SLOT_TOP := Vector3.UP * ROOM_SIZE
const SLOT_BOTTOM := Vector3.DOWN * ROOM_SIZE
const SLOT_LEFT := Vector3.LEFT * ROOM_SIZE
const SLOT_RIGHT := Vector3.RIGHT * ROOM_SIZE
# note: front/back are reversed in the map data
const SLOT_FRONT := Vector3.BACK * ROOM_SIZE
const SLOT_BACK := Vector3.FORWARD * ROOM_SIZE

onready var room_inner := $Rooms/RoomInner
onready var room_outer := $Rooms/RoomOuter
onready var room_top := $Rooms/RoomTop
onready var room_bottom := $Rooms/RoomBottom
onready var room_left := $Rooms/RoomLeft
onready var room_right := $Rooms/RoomRight
onready var room_front := $Rooms/RoomFront
onready var room_back := $Rooms/RoomBack

var Tesseract := preload("./TData.gd").new()
var data := Tesseract.data

func _ready():
	assert(Tesseract.is_valid())

	assert(room_inner)
	assert(room_inner.transform.origin == SLOT_INNER)

	assert(room_outer)
	assert(room_outer.transform.origin == SLOT_OUTER)

	assert(room_top)
	assert(room_top.transform.origin == SLOT_TOP)

	assert(room_bottom)
	assert(room_bottom.transform.origin == SLOT_BOTTOM)

	assert(room_left)
	assert(room_left.transform.origin == SLOT_LEFT)

	assert(room_right)
	assert(room_right.transform.origin == SLOT_RIGHT)

	assert(room_front)
	assert(room_front.transform.origin == SLOT_FRONT)

	assert(room_back)
	assert(room_back.transform.origin == SLOT_BACK)

static func _room_key(name: String) -> String:
	if name.find("_") > 0:
		return name
	return "ROOM_%s" % name.to_upper()

func _on_Tracker_player_changed_room(old_room, new_room):
	prints("player now in room '%s'" % new_room)

	var old_key = _room_key(old_room)
	var new_key = _room_key(new_room)
	var info = data[old_key]

	for key in info.keys():
		var connection = info[key]
		if connection.room != new_key:
			continue
		return _handle_transition(old_room, connection)

	assert(false, "Impossible transition (fauly data)")

func _handle_transition(old_room, connection):
	prints('transitioning...', old_room, connection)
	pass

# end
