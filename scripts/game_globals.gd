# This script is an Autoload
extends Node2D

const _HORIZON_FRACTION: float = 0.5

var player_node: Node2D = null
var track_node: Node2D = null
var screen_width: int = 0
var screen_height: int = 0
var horizon_y: float = 0 # Half screen

func _ready() -> void:
	print("GameGlobals is ready")

func update_screen_size() -> void:
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	horizon_y = -1 * _HORIZON_FRACTION * screen_height

func register_player(player: Node2D) -> void:
	if player_node != null:
		push_warning("A player node is already registered. Overwriting.")
	player_node = player
	print("Player registered")
	
func register_track(track: Node2D) -> void:
	if track_node != null:
		push_warning("A track node is already registered. Overwriting.")
	track_node = track
	print("Player registered")
