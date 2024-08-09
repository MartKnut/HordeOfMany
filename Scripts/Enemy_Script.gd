extends Area2D

var teleportable : bool = false
var right : bool
var player : Node
var globalPosition
var atkTimer : Timer

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
	atkTimer = $AttackTimer
	
	bigCollision.set_deferred("disabled", true)
	attackCollision.set_deferred("disabled", true)
	
	
	

func _enter_tree():
	globalPosition = global_position.x
	
	var b = randi_range(0,1)
	print(b)
	if b == 1: pass
	else:
		apply_scale(Vector2(-1,1))
	
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
		8:
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
	# Plays the attack, activates the "attack" hitbox and deactivates all other hitboxes.
	# The attack hitbox is very big and the last chance for the player to save themselves from
	# taking damage
	if canAttack:
		animatedSprite.play("attack")
		attackCollision.set_deferred("disabled", false)
		smallCollision.set_deferred("disabled", true)
		bigCollision.set_deferred("disabled", true)


func _on_animated_sprite_2d_animation_finished():
	# If attack animation is finished and enemy was not killed
	if animatedSprite.animation == "attack" and canAttack:
		# please do not attack multiple times instantly
		canAttack = false
		player.damage()
		atkTimer.wait_time = 1.5
		atkTimer.start()
		
		# reset collisions to something that makes sense
		bigCollision.set_deferred("disabled", false)
		attackCollision.set_deferred("disabled", true)
		
		# Mona_Lisa.png (not literally) until you're told to attack again
		canAttack = true
		animatedSprite.play("Stand")
	
	# could probably boil allat to one bool but eh...
	if (animatedSprite.animation != "attack" 
	and animatedSprite.animation != "approach" 
	and animatedSprite.animation != "Stand"):
		# DIE
		canAttack = false
		animatedSprite.visible = false


func _on_audio_stream_player_2d_finished():
	# ROT AWAY (delete from scene)
	# I'm not good enough to think about garbage collection and all that
	queue_free()
