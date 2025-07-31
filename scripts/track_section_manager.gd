extends Node2D

const TRACK_DATA_FILE: String = "res://assets/tracks/first_level.json"
var track_data: Array = []
var track_lines: Array[Node2D] = []
var screen_y_base: int = 0

var segment_0: Dictionary = {
	'y': 0,
	'dy': 1,
}
var segment_1: Dictionary = {
	'y': 0,
	'dy': 1,
}

const LineScene: PackedScene = preload("res://scenes/Line.tscn")

func _ready() -> void:
	GameGlobals.register_track(self)
	if GameGlobals.screen_height == 0:
		GameGlobals.update_screen_size()
	screen_y_base = GameGlobals.screen_height
	_load_track_data()
	_generate_track()

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

func _generate_track() -> void:
	print("Generating track from data")
	var line_accumulator = 0
	for iline in range(GameGlobals.LINES_PER_SCREEN):
		var current_line = LineScene.instantiate()
		current_line.position.x = 0
		current_line.position.y = -line_accumulator + screen_y_base
		current_line.configure_parameters()
		line_accumulator += current_line.line_width
		track_lines.append(current_line)
		add_child(current_line)
		current_line.queue_redraw()

func _physics_process(_delta: float) -> void:
	# Get player data to know how to advance
	var translation_speed = GameGlobals.get_player_track_speed()
	var start_coordinate = GameGlobals.get_player_track_coordinate()
	var end_coordinate = start_coordinate + GameGlobals.LINES_PER_SCREEN
	
	# Advance all lines based on the speed
	for line in track_lines:
		line.translate(Vector2(0, translation_speed))
		# if the line leaves the screen, add a new line on top
		if line.position.y - GameGlobals.LINE_WIDTH > screen_y_base:
			line.position.y -= GameGlobals.LINES_PER_SCREEN * GameGlobals.LINE_WIDTH
		line.update_size()
	#var lines_to_plot = track_lines.slice(start_coordinate, end_coordinate)
	# Called every frame
	# draw the allowed number of lines
	# trigonometry for line size
