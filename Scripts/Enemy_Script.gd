extends Area2D

var teleportable : bool = false
var right : bool
var player : Node
var globalPosition

var canAttack = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../PlayerScene"
	
	#globalPosition = global_position.x
	#if globalPosition <= 32:
		#teleportable = true
		#right = false
	#elif globalPosition >= 128:
		#teleportable = true
		#right = true
	#else:
		#teleportable = false
	#print(globalPosition)

func _enter_tree():
	globalPosition = global_position.x
	if globalPosition <= 32:
		teleportable = true
		right = false
	elif globalPosition >= 128:
		teleportable = true
		right = true
	else:
		teleportable = false
	print(globalPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if teleportable:
		if not right:
			if player.global_position.x >= 192:
				position.x = globalPosition+256
			elif player.global_position.x >= 0:
				position.x = globalPosition
		else:
			if player.global_position.x <= 64:
				position.x = globalPosition-256
			elif player.global_position.x >= 0:
				position.x = globalPosition

func die():
	canAttack = false
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer2D.play()
	$DeathTimer.start()

func initialize(start_position, player_position):
	position.x = start_position.x


func _on_death_timer_timeout():
	queue_free()
