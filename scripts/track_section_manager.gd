extends Node2D

const TRACK_DATA_FILE: String = "res://assets/tracks/first_level.json"
var track_data: Array = []
var track_lines: Array = []

const LineScene: PackedScene = preload("res://scenes/Line.tscn")

func _ready() -> void:
	_load_track_data()
	_generate_track_from_data()

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

func _configure_line_colors(line: Node2D, line_idx: int) -> Node2D:
	# TODO: add texture instead of manual lines
	line.edge_color = Color.WHITE_SMOKE
	line.road_color = Color.BLACK
	if line_idx % 2 == 0:
		line.outer_color = Color.DARK_SLATE_GRAY
	else:
		line.outer_color = Color.SLATE_GRAY
	return line

func _generate_track_from_data() -> void:
	print("Generating track from data")
	var y_base = -480
	for current_section in track_data:
		for iline in range(int(current_section.length)):
			print(str(iline))
			var current_line = LineScene.instantiate()
			current_line = _configure_line_colors(current_line, iline)
			current_line.position.x = 0
			current_line.position.y = current_line.line_width * iline + y_base
			track_lines.append(current_line)
			add_child(current_line)


func _process(delta: float) -> void:
	pass
