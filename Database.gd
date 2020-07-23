extends Node

const DB = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db: DB


func _ready():
	db = DB.new()
	assert(db)
	db.path = "game.db"
	assert(db.open_db())
#	db.drop_table("rooms")
	db.create_table(
		"rooms",
		{
			"id": {"data_type": "int", "primary_key": true, "not_null": true},
			"name": {"data_type": "text"}
		}
	)
	var rows = db.select_rows("rooms", "", ["*"])
	if rows.empty():
		db.insert_row("rooms", {"id": 0, "name": "The first room"})
	db.query("select max(id)+1 as next_id from rooms;")
	var next_id: int = db.query_result[0].next_id
	db.insert_row("rooms", {"id": next_id, "name": "Another room"})
	rows = db.select_rows("rooms", "", ["*"])
	prints('rows', rows)


func _exit_tree():
	db.close_db()
