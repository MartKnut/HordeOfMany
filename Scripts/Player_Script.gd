extends CharacterBody2D

# Public variables
@export var SPEED = 180.0
@export var HEALTH : int = 3
# Private variables
var canShoot : bool
var shootTimer
var animationPlayer : AnimationPlayer
var handling_input := true
var soundLeft
var soundRight
var tween

# Start
func _enter_tree():
	canShoot = true
	shootTimer = $CanShoot
	soundLeft = $Sound/SpawnSound2
	soundRight = $Sound/SpawnSound1
	
	

# Physics Update
func _physics_process(delta):
	
	if position.x >= 256:
		position.x = 0
	elif position.x <= -64:
		position.x = 192
	
	
	
	if not handling_input: 
		position.x +=10 * delta
		return
	_inputHandling()

func _inputHandling():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		#print(position.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var shoot = Input.is_action_just_pressed("Shoot")
	if shoot and canShoot:
		canShoot = false
		_shoot()
	
	
	move_and_slide()
	


func _shoot():
	$Sound/ShootSound.play()
	# Check if the raycast hits an item
	if $RayCast2D.is_colliding():
			#print($RayCast2D.get_collider().name)
			var hit = $RayCast2D.get_collider()
			if hit.is_in_group("enemy"): 
				hit.die()
	
	$AnimatedSprite2D2.play("shoot")
	
	
	shootTimer.start()



func playaudio(right:bool):
	if right:
		soundRight.play()
	else:
		soundLeft.play()
	

func damage():
	HEALTH -= 1
	tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color8(150,0,0,75), 0.1)
	tween.tween_property($ColorRect, "color", Color8(150,0,0,0), 0.2)
	
	if HEALTH >= 1: return
	handling_input = false
	$"../EnemySpawner".canSpawn = false
	print("owie")
	$UiScene.dead()
	$"../EnemySpawner".dead()

func _on_timer_timeout():
	
	canShoot = true

func _on_animation_finished():
	$AnimatedSprite2D2.play("default")

