extends Area2D

var teleportable : bool = true
var right : bool
var player : Node
var globalPosition

var canAttack = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = $"../../PlayerScene"
	globalPosition = global_position.x
	if position.x <= 64:
		teleportable = true
		right = false
	if position.x >= 192:
		teleportable = true
		right = true
	print(globalPosition)

func _enter_tree():
	globalPosition = global_position.x
	if position.x <= 64:
		teleportable = true
		right = false
	elif position.x >= 192:
		teleportable = true
		right = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if teleportable:
		if not right:
			if player.position.x >= 192:
				position.x = globalPosition+256
			elif player.position.x >= 0:
				position.x = globalPosition
		else:
			if player.position.x != 0:
				position.x = globalPosition-256
			elif player.position.x <= -192:
				position.x = globalPosition

func die():
	canAttack = false
	$AudioStreamPlayer2D.play()
	$DeathTimer.start()

func initialize(start_position, player_position):
	position.x = start_position.x


func _on_death_timer_timeout():
	queue_free()
