extends Node2D
class_name MonsterNode

const INITIAL_GAP = 500

var track_speed: float = 0
var track_coordinate: float = 0

func _ready() -> void:
	# This means the monster ALMOST gets you if you play perfectly. Need to adjust based on track
	track_speed = GameGlobals.get_player_track_velocity()
	track_coordinate = -INITIAL_GAP
	GameGlobals.register_monster(self)

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta
