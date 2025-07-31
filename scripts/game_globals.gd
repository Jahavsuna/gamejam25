# This script is an Autoload
extends Node2D

const LINES_PER_SCREEN: int = 120
const LINE_WIDTH: int = 2
const LINE_COLOR_SWICTH: int = 30

var track_speed: int = 120
var scale_rate: int = 1.8
var top_track_y: int = 240
var player_node: Node2D = null
var monster_node: Node2D = null
var track_node: Node2D = null
var screen_width: int = 0
var screen_height: int = 0
var horizon_y: float = 0 # Half screen

@export var DEBUG: bool = 1

func _ready() -> void:
	print("GameGlobals is ready")

func update_screen_size() -> void:
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	horizon_y = LINES_PER_SCREEN * LINE_WIDTH

func register_monster(monster: Node2D) -> void:
	if monster_node != null:
		push_warning("A monster node is already registered. Overwriting.")
	monster_node = monster
	print("Player registered")

func register_player(player: Node2D) -> void:
	if player_node != null:
		push_warning("A player node is already registered. Overwriting.")
	player_node = player
	player.z_index = 10	
	print("Player registered")

func get_player_track_coordinate() -> int:
	if player_node == null:
		push_error("Attempted to get player track_coord, but player doesn't exist.")
	return player_node.track_coordinate

func register_track(track: Node2D) -> void:
	if track_node != null:
		push_warning("A track node is already registered. Overwriting.")
	track_node = track
	print("Player registered")
	
