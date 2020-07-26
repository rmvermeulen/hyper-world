extends Spatial

const ROOM_SIZE := 20

const SLOT_INNER := Vector3() * ROOM_SIZE
const SLOT_OUTER := Vector3(10, 0, 0) * ROOM_SIZE
const SLOT_TOP := Vector3.UP * ROOM_SIZE
const SLOT_BOTTOM := Vector3.DOWN * ROOM_SIZE
const SLOT_LEFT := Vector3.LEFT * ROOM_SIZE
const SLOT_RIGHT := Vector3.RIGHT * ROOM_SIZE
# note: front/back in the map data are reversed of the Vector3 constants
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


func _ready():
	assert(OK == $Tracker.connect("changed_room", self, "_on_player_changed_room"))

	# check room size and alignment
	assert(room_inner)
	room_inner.transform.origin = SLOT_INNER
	assert(room_inner.transform.origin == SLOT_INNER)

	assert(room_outer)
	room_outer.transform.origin = SLOT_OUTER
	assert(room_outer.transform.origin == SLOT_OUTER)

	assert(room_top)
	room_top.transform.origin = SLOT_TOP
	assert(room_top.transform.origin == SLOT_TOP)

	assert(room_bottom)
	room_bottom.transform.origin = SLOT_BOTTOM
	assert(room_bottom.transform.origin == SLOT_BOTTOM)

	assert(room_left)
	room_left.transform.origin = SLOT_LEFT
	assert(room_left.transform.origin == SLOT_LEFT)

	assert(room_right)
	room_right.transform.origin = SLOT_RIGHT
	assert(room_right.transform.origin == SLOT_RIGHT)

	assert(room_front)
	room_front.transform.origin = SLOT_FRONT
	assert(room_front.transform.origin == SLOT_FRONT)

	assert(room_back)
	room_back.transform.origin = SLOT_BACK
	assert(room_back.transform.origin == SLOT_BACK)

	# check tracker size and alignment
	var inner = $Tracker/Inner
	assert(inner.transform.origin == SLOT_INNER)
	var front = $Tracker/Front
	assert(front.transform.origin == SLOT_FRONT)
	var back = $Tracker/Back
	assert(back.transform.origin == SLOT_BACK)
	var s1 = inner.get_child(0).shape
	var s2 = front.get_child(0).shape
	var s3 = back.get_child(0).shape

	assert(s1 != null)
	assert(s2 == s1)
	assert(s3 == s2)

	var room_quadrant := 0.5 * ROOM_SIZE * Vector3(1, 1, 1)
	s1.extents = room_quadrant
	assert(s1.extents == room_quadrant)


func _on_player_changed_room(new_room: String):
	prints("player now in room '%s'" % new_room)

# end
