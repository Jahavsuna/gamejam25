extends Node2D

@onready var loop_line = preload("res://scenes/LoopLine.tscn")
@onready var gate = preload("res://scenes/GateObstacle.tscn")

const TRACK_DATA_FILE: String = "res://assets/tracks/first_level.json"
var track_lines: Array[Node2D] = []
var track_data: Array = []
var segment_ends: Array = []
var active_segment = 0
var lowest_line_idx: int = 0

var finish_line_in_view = false
var finish_line_scene = preload("res://scenes/FinishLine.tscn")

const LineScene: PackedScene = preload("res://scenes/Line.tscn")

func _ready() -> void:
	GameGlobals.register_track(self)
	if GameGlobals.screen_height == 0:
		GameGlobals.update_screen_size()
	_load_track_data()
	_generate_track()
	_load_nth_track_data(0)

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
	
func track_obj_sort(a, b):
	return a.y < b.y

func _load_nth_track_data(n) -> void:
	var cur_track = track_data[n]
	if not "objects" in cur_track: return
	
	var objects_arr = cur_track["objects"]
	var objects = []
	for obj in objects_arr:
		var new_obj = null		
		if obj[0] == "LoopZone":
			new_obj = loop_line.instantiate()
			print(obj)
			new_obj.loop_to_segment = int(obj[4])
			new_obj.safe_zone = int(obj[3])
		elif obj[0] == "Gate":
			new_obj  = gate.instantiate()
			
		if new_obj:
			new_obj.visibility_layer = 100000;
			new_obj.z_index = 1000
			new_obj.position = Vector2(obj[2] + GameGlobals.screen_width/2, obj[1] + GameGlobals.TRACK_PER_SCREEN)
		new_obj.visible=false
		add_child(new_obj)
		
		
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

func set_active_segment(seg_i:int):
	active_segment = seg_i

func draw_finish_line():
	var finish_line = finish_line_scene.instantiate()
	finish_line.position = Vector2(GameGlobals.screen_width / 2, GameGlobals.horizon_y)
	add_child(finish_line)

func _physics_process(delta: float) -> void:
	# Avoid running this befor the function is ready
	if not GameGlobals.is_screen_size_ready: return
	
	# Get player data and advance segment if needed
	var translation_speed = GameGlobals.track_speed
	var start_coordinate = GameGlobals.get_player_track_coordinate()
	if start_coordinate > segment_ends[active_segment]:
		print("Segment advanced!")
		active_segment += 1
		_load_nth_track_data(active_segment)
		print("Current Segment = ", active_segment)
	
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
			# Only advance the index if the active segment is not the last one
			if active_segment < track_data.size() - 1:
				line_dx = track_data[active_segment + 1]["dx"]
			else:
				line_dx = 0
				line_ddx = 0
		else:
			line_dx = track_data[active_segment]["dx"]
		line_ddx += line_dx
		
		# Offset the line
		line.x_offset = line_ddx
		line.update_size()
	
	# If we are in the last segment, need to add finish line and ghost segment
	var distance_from_finish_line = segment_ends[-1] - start_coordinate
	if distance_from_finish_line <= GameGlobals.TRACK_PER_SCREEN * 5:
		if not finish_line_in_view:
			finish_line_in_view = true
			draw_finish_line()
