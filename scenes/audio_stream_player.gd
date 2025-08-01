extends AudioStreamPlayer

# walking
func _ready() -> void:
	self.play()

func _process(_delta: float) -> void:
	if not self.playing:  self.play()
	var player = get_parent()
	if player.direction.x == 0 and player.direction.y >= 0 :
		self.pitch_scale = .7
	else:
		self.pitch_scale = 1
