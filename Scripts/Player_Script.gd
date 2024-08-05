extends CharacterBody2D

# Public variables
@export var SPEED = 100.0

# Private variables
var canShoot : bool

# Start
func _enter_tree():
	canShoot = true

# Physics Update
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		#print(position.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if position.x >= 256:
		position.x = 0
	elif position.x <= -64:
		position.x = 192
	
	var shoot = Input.is_action_just_pressed("Shoot")
	if shoot and canShoot:
		canShoot = false
		_shoot()
	
	move_and_slide()


func _shoot():
	# Check if the raycast hits an item
	if $RayCast2D.is_colliding():
			print($RayCast2D.get_collider().name)
			var hit = $RayCast2D.get_collider()
			if hit.is_in_group("enemy"): 
				hit.die()
	
	$AnimatedSprite2D2.visible = true
	
	$Timer.start()

func playaudio(right:bool):
	if right:
		$Sound/SpawnSound2.play()
	else:
		$Sound/SpawnSound1.play()
	

func _on_timer_timeout():
	$AnimatedSprite2D2.visible = false
	canShoot = true
