extends AudioStreamPlayer

#breathing
func _ready() -> void:
	self.play()

func _process(_delta: float) -> void:
	var player = get_parent()
	if player.direction.x == 0 and player.direction.y >= 0 : self.stop()
	
	if not self.playing:  self.play()
			
