extends Node2D

var track_coordinate: int = 0
var track_speed: int = 100

func _ready() -> void:
	GameGlobals.register_player(self)
	print("Player initialized")

func _physics_process(delta: float) -> void:
	track_coordinate += track_speed * delta

func _process(delta):
	var direction = Vector2.ZERO
	# Detect continuous movement input using UI actions (configured in Project Settings -> Input Map)
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	var player_sprite = $PlayerAnimSprite as AnimatedSprite2D
	
	if direction.x > 0:
		player_sprite.play("right")
	elif direction.x < 0:
		player_sprite.play("left")
	else:
		player_sprite.play("straight")
	
	self.position += direction*30*delta;
	#translate(direction * delta);
	#self.transform.translated()
	#(direction * delta);
	
		
