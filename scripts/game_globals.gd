# This script is an Autoload
extends Node2D

var is_screen_size_ready: bool = false

const LINES_PER_SCREEN: int = 120
const LINE_WIDTH: int = 2
const LINE_COLOR_SWICTH: int = 30
const TRACK_PER_SCREEN: float = 10.0

var track_speed: int = 100
var scale_rate: int = 1.6
var top_track_y: int = 200
var player_node: Node2D = null
var monster_node: Node2D = null
var track_node: Node2D = null
var screen_width: int = 0
var screen_height: int = 0
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
