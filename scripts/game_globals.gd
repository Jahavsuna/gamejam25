# This script is an Autoload
extends Node2D

var is_screen_size_ready: bool = false

const LINES_PER_SCREEN: int = 120
const LINE_WIDTH: int = 2
const LINE_COLOR_SWICTH: int = 30
const TRACK_PER_SCREEN: float = 10.0
const VISION_ANGLE_RAD: float = 25 * 3.14 / 180

var scale_rate: float = 1.3
var player_node: PlayerNode = null
var monster_node: MonsterNode = null
var track_node: TrackMgr = null
var screen_width: float = 0
var screen_height: float = 0
var horizon_y: float = 0

@export var DEBUG: bool = 1

func _ready() -> void:
	is_screen_size_ready = false
	print("GameGlobals is ready")

func update_screen_size() -> void:
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	horizon_y = LINES_PER_SCREEN * LINE_WIDTH
	is_screen_size_ready = true

func register_monster(monster: Node2D) -> void:
	if monster_node != null:
		push_warning("A monster node is already registered. Overwriting.")
	monster_node = monster
	print("Player registered")

func get_monster_track_coordinate() -> float:
	if monster_node == null:
		push_error("Attempted to read monster data, but no monster was registered.")
		return -1
	return monster_node.track_coordinate

func register_player(player: Node2D) -> void:
	if player_node != null:
		push_warning("A player node is already registered. Overwriting.")
	player_node = player
	player.z_index = 10
	print("Player registered")

func get_player_track_coordinate() -> float:
	if player_node == null:
		push_error("Attempted to get player track_coord, but player doesn't exist.")
		return -1
	return player_node.track_coordinate

func get_player_screen_position() -> Vector2:
	if player_node == null:
		push_error("Attempted to get player track_coord, but player doesn't exist.")
	return player_node.get_child(0).position

func get_player_track_velocity() -> float:
	if player_node == null:
		push_error("Attempted to get player track_v, but player doesn't exist.")
	return player_node.player_track_v

func register_track(track: Node2D) -> void:
	if track_node != null:
		push_warning("A track node is already registered. Overwriting.")
	track_node = track
	print("Player registered")

func get_track_end_coordinate() -> float:
	if track_node == null:
		push_error("Attempted to get track end coordinate, but track doesn't exist.")
		return -1
	return track_node.segment_ends[-1]

func get_current_dx() -> float:
	if track_node == null:
		push_error("Attempted to get track dx, but track isn't registered in Globals.")
		return -1.0
	return track_node.track_data[track_node.active_segment]["dx"]

func get_road_fraction(position_y: float) -> float:
	return (screen_height - position_y) / (screen_height - horizon_y)

func get_line_by_y(y: float) -> TrackLine:
	var closest_line: TrackLine = track_node.track_lines[0]
	var nearest_line_dist = screen_height
	for line in track_node.track_lines:
		var curr_line_dist = abs(line.position.y - y)
		if curr_line_dist < nearest_line_dist:
			closest_line = line
			nearest_line_dist = curr_line_dist
	return closest_line

func perform_loop(target_segment: int) -> void:
	var new_player_coord = track_node.segment_starts[target_segment]
	var monster_player_dist = player_node.track_coordinate - monster_node.track_coordinate
	var new_monster_coord = new_player_coord - monster_player_dist
	monster_node.track_coordinate = new_monster_coord
	player_node.track_coordinate = new_player_coord
	track_node.update_segment(target_segment)
