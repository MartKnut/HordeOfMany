extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	pass
	
	
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
	if shoot:
		_shoot()
	
	move_and_slide()

func _shoot():
	if $RayCast2D.is_colliding():
			print($RayCast2D.get_collider().name)
			var hit = $RayCast2D.get_collider()
			hit.queue_free()
