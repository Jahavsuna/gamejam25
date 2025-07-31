extends Node2D

const INITIAL_GAP = 500

var speed: int = 0
var track_coordinate: int = 0

func _ready() -> void:
	speed = 50
	track_coordinate = -INITIAL_GAP
