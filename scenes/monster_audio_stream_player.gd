extends AudioStreamPlayer


@onready var sound_1 = ResourceLoader.load("res://assets/sounds/knife_1.wav")
@onready var sound_2 = ResourceLoader.load("res://assets/sounds/knife_2.wav")
@onready var sound_3 = ResourceLoader.load("res://assets/sounds/knife_3.wav")

var sound_i = 0
var sounds_array = []
func _ready() -> void:
	sounds_array = [sound_1, sound_2, sound_2, sound_2, sound_3]
	
func _volume_db_from_coordinate_delta(coordinate_delta: float)-> float:
	return 2-coordinate_delta
	
func _process(_delta: float) -> void:
	if self.playing: return
	else: sound_i += 1
	if sound_i >= len(sounds_array):
		sound_i = 0
	self.set_stream(sounds_array[sound_i])
	var coordinate_delta = GameGlobals.get_player_track_coordinate() - GameGlobals.get_monster_track_coordinate()
	self.volume_db = max(self._volume_db_from_coordinate_delta(coordinate_delta), -10)
	self.play()
	
	
