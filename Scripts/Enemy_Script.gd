extends Area2D

var teleportable : bool = false
var right : bool
var player : Node
var globalPosition

var canAttack = true
var animationSequence : int
var deathAnimation = "Death1"

var bigCollision : CollisionShape2D
var smallCollision : CollisionShape2D
var attackCollision : CollisionShape2D

var animatedSprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../PlayerScene"
	bigCollision = $BigCollision
	smallCollision = $SmallCollision
	animatedSprite = $AnimatedSprite2D
	attackCollision = $AttackCollision
	
	bigCollision.set_deferred("disabled", true)
	attackCollision.set_deferred("disabled", true)

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
	#print(globalPosition)

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
	
	if animatedSprite.animation == "approach":
		animationSequence = animatedSprite.frame
	
	match animationSequence:
		0:
			deathAnimation = "Death0"
		6:
			deathAnimation = "Death1"
		12:
			deathAnimation = "Death2"
		14:
			deathAnimation = "Death3"
			smallCollision.set_deferred("disabled", true)
			bigCollision.set_deferred("disabled", false)
		16:
			deathAnimation = "Death4"
		19:
			deathAnimation = "Death5"
			

func die():
	canAttack = false
	animatedSprite.play(deathAnimation)
	bigCollision.disabled = true
	smallCollision.disabled = true
	$AudioStreamPlayer2D.play()
	#$DeathTimer.start()
	$"../../GameManager".increaseScore()

func initialize(start_position, player_position):
	position.x = start_position.x


#func _on_death_timer_timeout():
	#queue_free()


func _on_attack_timer_timeout():
	if canAttack:
		animatedSprite.play("attack")
		attackCollision.set_deferred("disabled", false)
		smallCollision.set_deferred("disabled", true)
		bigCollision.set_deferred("disabled", true)


func _on_animated_sprite_2d_animation_finished():
	if animatedSprite.animation == "attack" and canAttack:
		canAttack = false
		$"../../PlayerScene".damage()
	if animatedSprite.animation != "attack" and animatedSprite.animation != "approach":
		canAttack = false
		animatedSprite.visible = false


func _on_audio_stream_player_2d_finished():
	queue_free()
