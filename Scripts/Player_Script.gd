extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		print(position.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if self.position.x >= 256:
		self.position.x = 0
	elif self.position.x <= -64:
		self.position.x = 192
	
	var shoot = Input.is_action_just_pressed("Shoot")
	if shoot:
		_shoot()
	
	
	move_and_slide()

func _shoot():
	pass
