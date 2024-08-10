extends Area2D

# Public variables
@export var SPEED = 2.2
@export var Health : int = 3 # like all good things
@export var Bullet : PackedScene

# Private variables
var canShoot : bool
var shootTimer
var animationPlayer : AnimationPlayer
var handling_input := true
var soundLeft
var soundRight
var tween
var ray : RayCast2D

var gunSprite : AnimatedSprite2D
var muzzleFlash : AnimatedSprite2D

var bobTime : float

var enemiesRaycasted = []

# Start
func _enter_tree():
	canShoot = true
	shootTimer = $CanShoot
	soundLeft = $Sound/SpawnSound2
	soundRight = $Sound/SpawnSound1
	gunSprite = $Node2D/Gun
	muzzleFlash = $Node2D/Flash
	ray = $RayCast2D
	


# Physics Update
func _physics_process(delta):
	# wrap around
	if position.x >= 256:
		position.x = 0
	elif position.x <= -64:
		position.x = 192
	
	# if you're dead start scrolling the map and skip everything else
	if not handling_input: 
		position.x +=16 * delta
		return
	_inputHandling(delta)

func _inputHandling(delta):
	# Get the input direction and handle the movement/deceleration.
	# all this is mostly just the default move script that godot gives you
	var direction = Input.get_axis("Left", "Right")
	if direction:
		position.x += direction * SPEED
		bobTime += delta
		# bobs animations
		# don't worry I'll turn it off for you
		#position += Vector2(0, getSine())
		
		$Node2D.position += Vector2(getSineX(),getSineY())
		
	else:
		position.x = position.x
	
	# if shoot and can shoot, shoot shoot. simple as
	var shoot = Input.is_action_just_pressed("Shoot")
	if shoot and canShoot:
		canShoot = false
		_shoot()


func _shoot():
	gunSprite.play("recoil")
	
	var bul = Bullet.instantiate()
	bul.initialize(position.x)
	get_parent().add_child(bul)
	
	# pew pew
	# fun fact the shoot sound is just me saying P with a couple edits
	$Sound/ShootSound.play()
	
	## Check if the raycast hits an item
	if ray.is_colliding():
		print(ray.get_collider().name)
		var hit = ray.get_collider()
		if hit.is_in_group("enemy"): 
			hit.die()
	
	
	muzzleFlash.play("shoot")
	shootTimer.start()

# redundant comment
func playaudio(right:bool):
	if right:
		soundRight.play()
	else:
		soundLeft.play()
	

func damage():
	# ow
	Health -= 1
	
	# tell the player it hurt by hurting their eyes
	tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color8(150,0,0,75), 0.1)
	tween.tween_property($ColorRect, "color", Color8(150,0,0,0), 0.2)
	
	# if it hurts too little, stop here 
	if Health >= 1: return
	
	# if it hurts too much, die
	handling_input = false
	# mercy rule
	$"../EnemySpawner".canSpawn = false
	print("owie") # indeed
	$UiScene.dead()
	$"../EnemySpawner".dead()

func getSineX():
	# you can also try to tweak this if you didn't think the bobbing was nauseating enough before
	return sin(bobTime * 7.5) * 0.15

func getSineY():
	return sin(bobTime * 15) * 0.3


# get ready to shoot again
func _on_timer_timeout():
	canShoot = true

# muzzle flash animation. Why in animatedsprite is "Loop" set to on by default, anyway?
func _on_animation_finished():
	muzzleFlash.play("default")



func _on_gun_animation_finished():
	if gunSprite.animation == "recoil":
		gunSprite.play("default")
