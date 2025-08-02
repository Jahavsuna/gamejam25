extends Node2D
class_name MonsterNode

const INITIAL_GAP: float = 300
const MAX_VOLUME_BUFFER: float = 100
const MIN_VOLUME: float = -20
const MAX_VOLUME: float = 10

var track_speed: float = 0
var track_coordinate: float = 0
var KnifeSound: AudioStreamPlayer
var NyxSound: AudioStreamPlayer

func _ready() -> void:
	track_speed = GameGlobals.get_player_track_velocity()
	track_coordinate = -INITIAL_GAP
	KnifeSound = $KnifeSound
	NyxSound = $NyxSound
	GameGlobals.register_monster(self)

func _volume_db_from_coordinate_delta(dist: float) -> float:
	# Real sound decays like r^2. In dB, that means A-20log(r)
	var distance_ratio = max(0.0, (dist - MAX_VOLUME_BUFFER) / INITIAL_GAP)
	var gain = -20 * (log(distance_ratio) / log(10))
	return MIN_VOLUME + gain

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta
	var distance_from_player = GameGlobals.get_player_track_coordinate() - track_coordinate
	
	var new_volume = _volume_db_from_coordinate_delta(distance_from_player)
	KnifeSound.volume_db = min(new_volume, MAX_VOLUME)
	NyxSound.volume_db = min(new_volume, MAX_VOLUME)
