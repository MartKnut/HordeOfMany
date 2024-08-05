extends Node

# Public Variables
@export var zomb : PackedScene
@export var startWaitTime : float = 6
@export var expoDiffScaling : float = 2
@export var minDelay : float = 1.8

# Private Variables
var spawnDelay : float
var spawnedEnemies : int
var gameTime : float
var mobs : Array[Node]
var wave : int
# Called when the node enters the scene tree for the first time.
func _ready():
	spawnDelay = startWaitTime
	mobs = get_children()
	#print(mobs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout():
	# Create a new instance of the Mob scene.
	var _mob = zomb.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player = $"../PlayerScene"
	_mob.initialize(mob_spawn_location.position, player.position)
	var distanceFromPlayer = player.position - mob_spawn_location.position
	
	#print("player is at: " , player.position.x , ", and the mob is at: " , 
		  #mob_spawn_location.position.x , ", the distance from the player is :" , distanceFromPlayer)
	
	
	if distanceFromPlayer.x >= 127:
		player.playaudio(false)
	elif distanceFromPlayer.x >= 0:
		player.playaudio(true)
	elif distanceFromPlayer.x <= -128:
		player.playaudio(true)
	elif distanceFromPlayer.x <= 0:
		player.playaudio(false)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(_mob)
	mobs = get_children()
	#print(mobs)
	
	spawnedEnemies += 1
	
	if minDelay <= 0:
		minDelay = 1
	elif spawnDelay >= minDelay:
		spawnDelay = startWaitTime - 0.1 * (expoDiffScaling**(spawnedEnemies / spawnDelay))
		print("Time reduced by: " , 0.1 * (expoDiffScaling**(spawnedEnemies / spawnDelay)))
	else:
		$SpawnTimer.wait_time = minDelay
		spawnDelay = startWaitTime
		expoDiffScaling += 0.05
		minDelay -= 0.1
		spawnedEnemies = 0
		wave = wave + 1
		
		print("New Spawn Delay: ", spawnDelay, " New Difficulty Multiplier: ", expoDiffScaling, " New Min Delay: ", minDelay, " Wave: ", wave)
		
	
	
	if spawnDelay <= minDelay:
		$SpawnTimer.wait_time = minDelay
	elif spawnDelay >= minDelay:
		$SpawnTimer.wait_time = spawnDelay
	
	
	print("Spawn Delay: " , spawnDelay)
	
