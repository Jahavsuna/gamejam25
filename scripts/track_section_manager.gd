extends Node2D

var track_data: Array = []
const TRACK_DATA_FILE: String = "res://assets/tracks/first_level.json"

func _ready() -> void:
	_load_track_data()

func _load_track_data() -> void:
	var file = FileAccess.open(TRACK_DATA_FILE, FileAccess.READ)
	var json_string = file.get_as_text()
	var parse_result = JSON.parse_string(json_string)
	if parse_result is Array:
		print("Loaded JSON, detected array")
		track_data = parse_result
	else:
		print("ERROR: Failed to load JSON from " + TRACK_DATA_FILE)
	file.close()
