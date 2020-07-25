extends Node

# surface rooms
const ROOM_INNER := "ROOM_INNER"
const ROOM_OUTER := "ROOM_OUTER"
const ROOM_FRONT := "ROOM_FRONT"
const ROOM_BACK := "ROOM_BACK"
const ROOM_LEFT := "ROOM_LEFT"
const ROOM_RIGHT := "ROOM_RIGHT"
const ROOM_TOP := "ROOM_TOP"
const ROOM_BOTTOM := "ROOM_BOTTOM"

# room connections
const SIDE_TOP := "SIDE_TOP"
const SIDE_BOTTOM := "SIDE_BOTTOM"
const SIDE_LEFT := "SIDE_LEFT"
const SIDE_RIGHT := "SIDE_RIGHT"
const SIDE_FRONT := "SIDE_FRONT"
const SIDE_BACK := "SIDE_BACK"

# think of dali's cross for a map!
# also think of the 3d projection of a tesseract!

const DEG_90 := 0.5 * PI
const NONE := Transform()
var TURN_LEFT := Transform().rotated(Vector3.UP, DEG_90)
var TURN_RIGHT := Transform().rotated(Vector3.UP, -DEG_90)
var PITCH_UP := Transform().rotated(Vector3.LEFT, DEG_90)
var PITCH_DOWN := Transform().rotated(Vector3.LEFT, -DEG_90)
var ROLL_LEFT := Transform().rotated(Vector3.FORWARD, DEG_90)
var ROLL_RIGHT := Transform().rotated(Vector3.FORWARD, -DEG_90)

var data := {
	ROOM_INNER:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_BOTTOM, "transform": NONE},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_TOP, "transform": NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_RIGHT, "transform": NONE},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_LEFT, "transform": NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_BACK, "transform": NONE},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_FRONT, "transform": NONE},
	},
	ROOM_OUTER:
	{
		SIDE_TOP: {"room": ROOM_BOTTOM, "side": SIDE_BOTTOM, "transform": NONE},
		SIDE_BOTTOM: {"room": ROOM_TOP, "side": SIDE_TOP, "transform": NONE},
		SIDE_LEFT: {"room": ROOM_RIGHT, "side": SIDE_LEFT, "transform": NONE},
		SIDE_RIGHT: {"room": ROOM_LEFT, "side": SIDE_RIGHT, "transform": NONE},
		SIDE_FRONT: {"room": ROOM_BACK, "side": SIDE_FRONT, "transform": NONE},
		SIDE_BACK: {"room": ROOM_FRONT, "side": SIDE_BACK, "transform": NONE},
	},
	ROOM_FRONT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_FRONT, "transform": PITCH_UP},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_FRONT, "transform": PITCH_DOWN},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_FRONT, "transform": TURN_RIGHT},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_FRONT, "transform": TURN_LEFT},
		SIDE_FRONT: {"room": ROOM_OUTER, "side": SIDE_BACK, "transform": NONE},
		SIDE_BACK: {"room": ROOM_INNER, "side": SIDE_FRONT, "transform": NONE},
	},
	ROOM_BACK:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_BACK, "transform": PITCH_DOWN},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_BACK, "transform": PITCH_UP},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_BACK, "transform": TURN_LEFT},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_BACK, "transform": TURN_RIGHT},
		SIDE_FRONT: {"room": ROOM_INNER, "side": SIDE_BACK, "transform": NONE},
		SIDE_BACK: {"room": ROOM_OUTER, "side": SIDE_FRONT, "transform": NONE},
	},
	ROOM_LEFT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_LEFT, "transform": ROLL_LEFT},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_LEFT, "transform": ROLL_RIGHT},
		SIDE_LEFT: {"room": ROOM_OUTER, "side": SIDE_RIGHT, "transform": NONE},
		SIDE_RIGHT: {"room": ROOM_INNER, "side": SIDE_LEFT, "transform": NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_LEFT, "transform": TURN_LEFT},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_LEFT, "transform": TURN_RIGHT},
	},
	ROOM_RIGHT:
	{
		SIDE_TOP: {"room": ROOM_TOP, "side": SIDE_RIGHT, "transform": ROLL_RIGHT},
		SIDE_BOTTOM: {"room": ROOM_BOTTOM, "side": SIDE_RIGHT, "transform": ROLL_LEFT},
		SIDE_LEFT: {"room": ROOM_INNER, "side": SIDE_RIGHT, "transform": NONE},
		SIDE_RIGHT: {"room": ROOM_OUTER, "side": SIDE_LEFT, "transform": NONE},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_RIGHT, "transform": TURN_RIGHT},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_RIGHT, "transform": TURN_LEFT},
	},
	ROOM_TOP:
	{
		SIDE_TOP: {"room": ROOM_OUTER, "side": SIDE_BOTTOM, "transform": NONE},
		SIDE_BOTTOM: {"room": ROOM_INNER, "side": SIDE_TOP, "transform": NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_TOP, "transform": ROLL_RIGHT},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_TOP, "transform": ROLL_LEFT},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_TOP, "transform": PITCH_DOWN},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_TOP, "transform": PITCH_UP},
	},
	ROOM_BOTTOM:
	{
		SIDE_TOP: {"room": ROOM_INNER, "side": SIDE_BOTTOM, "transform": NONE},
		SIDE_BOTTOM: {"room": ROOM_OUTER, "side": SIDE_TOP, "transform": NONE},
		SIDE_LEFT: {"room": ROOM_LEFT, "side": SIDE_BOTTOM, "transform": ROLL_LEFT},
		SIDE_RIGHT: {"room": ROOM_RIGHT, "side": SIDE_BOTTOM, "transform": ROLL_RIGHT},
		SIDE_FRONT: {"room": ROOM_FRONT, "side": SIDE_BOTTOM, "transform": PITCH_UP},
		SIDE_BACK: {"room": ROOM_BACK, "side": SIDE_BOTTOM, "transform": PITCH_DOWN},
	},
}


func is_valid() -> bool:
	# assert that each side is
	# defined correctly (inverse) in both places
	for room_key in data.keys():
		var room = data[room_key]
		for conn_key in room.keys():
			var conn = room[conn_key]
			assert(conn.room is String)
			assert(conn.side is String)
			assert(conn.transform is Transform)

			assert(data.has(conn.room), "Invalid room")
			var other = data[conn.room]

			assert(other.has(conn.side), "Invalid side")
			var t: Transform = other[conn.side].transform

			assert(
				t.inverse() == conn.transform,
				"Unmirrored transform! %s/%s -> %s/%s" % [room_key, conn_key, conn.room, conn.side]
			)
	return true


# leave <room> via <side>, get next room
func transition(room: String, side: String) -> Dictionary:
	var conn = data[room][side]
	return data[conn.room]

# end
