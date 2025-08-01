extends Node2D

const INITIAL_GAP = 500

var track_speed: float = 0
var track_coordinate: float = 0

func _ready() -> void:
	track_speed = 50
	track_coordinate = -INITIAL_GAP
	GameGlobals.register_monster(self)

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta
