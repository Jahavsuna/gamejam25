extends Node2D

var track_coordinate: int = 0
var track_speed: int = 0

func _ready() -> void:
	GameGlobals.register_player(self)
	print("Player initialized")

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta
