extends Reference

static func create():
	var flip := deg2rad(180)
	var turn_right := deg2rad(-90)
	var turn_left := -turn_right
	return {
		"front":
		{
			"north": {"id": "top", "connection": "south", "angle": 0},
			"south": {"id": "bottom", "connection": "north", "angle": 0},
			"east": {"id": "right", "connection": "west", "angle": 0},
			"west": {"id": "left", "connection": "east", "angle": 0},
		},
		"back":
		{
			"north": {"id": "top", "connection": "north", "angle": flip},
			"south": {"id": "bottom", "connection": "south", "angle": flip},
			"east": {"id": "left", "connection": "west", "angle": 0},
			"west": {"id": "right", "connection": "east", "angle": 0},
		},
		"left":
		{
			"north": {"id": "top", "connection": "west", "angle": turn_left},
			"south": {"id": "bottom", "connection": "east", "angle": turn_right},
			"east": {"id": "front", "connection": "west", "angle": 0},
			"west": {"id": "back", "connection": "east", "angle": 0},
		},
		"right":
		{
			"north": {"id": "top", "connection": "east", "angle": turn_right},
			"south": {"id": "bottom", "connection": "west", "angle": turn_left},
			"east": {"id": "back", "connection": "west", "angle": 0},
			"west": {"id": "front", "connection": "east", "angle": 0},
		},
		"top":
		{
			"north": {"id": "back", "connection": "north", "angle": flip},
			"south": {"id": "front", "connection": "north", "angle": 0},
			"east": {"id": "right", "connection": "north", "angle": turn_left},
			"west": {"id": "left", "connection": "north", "angle": turn_right},
		},
		"bottom":
		{
			"north": {"id": "front", "connection": "south", "angle": 0},
			"south": {"id": "back", "connection": "south", "angle": flip},
			"east": {"id": "right", "connection": "south", "angle": turn_right},
			"west": {"id": "left", "connection": "south", "angle": turn_left},
		},
	}
