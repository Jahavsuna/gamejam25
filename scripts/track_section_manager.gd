extends Node2D

const TRACK_DATA_FILE: String = "res://assets/tracks/first_level.json"
var track_lines: Array[Node2D] = []
var track_data: Array = []
var segment_ends: Array = []
var active_segment = 0
var lowest_line_idx: int = 0

const LineScene: PackedScene = preload("res://scenes/Line.tscn")

func _ready() -> void:
	GameGlobals.register_track(self)
	if GameGlobals.screen_height == 0:
		GameGlobals.update_screen_size()
	_load_track_data()
	_generate_track()

func _load_track_data() -> void:
	var file = FileAccess.open(TRACK_DATA_FILE, FileAccess.READ)
	var json_string = file.get_as_text()
	var parse_result = JSON.parse_string(json_string)
	var distance_accumulator = 0
	if parse_result is Array:
		print("Loaded JSON, detected array")
		for p in parse_result:
			track_data.append(p)
			distance_accumulator += p["length"]
			segment_ends.append(distance_accumulator)
	else:
		print("ERROR: Failed to load JSON from " + TRACK_DATA_FILE)
	file.close()

func _generate_track() -> void:
	print("Generating track from data")
	var line_accumulator = 0
	for iline in range(GameGlobals.LINES_PER_SCREEN):
		var current_line = LineScene.instantiate()
		current_line.position.x = 0
		current_line.position.y = GameGlobals.screen_height - line_accumulator
		current_line.configure_parameters()
		line_accumulator += current_line.line_width
		track_lines.append(current_line)
		add_child(current_line)
		current_line.queue_redraw()

func _get_line_track_offset(line: Node2D) -> float:
	var line_y_span = line.position.y - GameGlobals.horizon_y
	var screen_y_span = GameGlobals.screen_height - GameGlobals.horizon_y
	var line_y_portion = line_y_span / screen_y_span
	var line_track_offset = (1 - line_y_portion) * GameGlobals.TRACK_PER_SCREEN
	return line_track_offset

func _physics_process(delta: float) -> void:
	# Avoid running this befor the function is ready
	if not GameGlobals.is_screen_size_ready: return
	
	# Get player data and advance segment if needed
	var translation_speed = GameGlobals.get_player_track_speed()
	var start_coordinate = GameGlobals.get_player_track_coordinate()
	if start_coordinate > segment_ends[active_segment]:
		print("Segment advanced!")
		active_segment += 1
	
	# Define offset parameters
	var line_ddx = 0
	var line_dx = 0
	
	# Iterate over all lines from bottom to top
	for _iline in range(lowest_line_idx, lowest_line_idx + GameGlobals.LINES_PER_SCREEN):
		var iline = _iline % GameGlobals.LINES_PER_SCREEN
		var line = track_lines[iline]
		
		# Advance all lines, and loop if necessary
		line.translate(Vector2(0, translation_speed * delta))
		if line.position.y + line.line_width > GameGlobals.screen_height:
			line.position.y -= line.line_width * GameGlobals.LINES_PER_SCREEN
			lowest_line_idx = (lowest_line_idx + 1) % GameGlobals.LINES_PER_SCREEN
	
	# Iterate after reordering
	for _iline in range(lowest_line_idx, lowest_line_idx + GameGlobals.LINES_PER_SCREEN):
		var iline = _iline % GameGlobals.LINES_PER_SCREEN
		var line = track_lines[iline]
		# Calculate the linex offset based on segment
		var line_track_coord = start_coordinate + _get_line_track_offset(line)
		if line_track_coord >= segment_ends[active_segment]:
			line_dx = track_data[active_segment + 1]["dx"]
		else:
			line_dx = track_data[active_segment]["dx"]
		line_ddx += line_dx
		
		# Offset the line
		line.x_offset = line_ddx
		line.update_size()
