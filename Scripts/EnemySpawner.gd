extends Node

# Public Variables
@export var zomb : PackedScene
@export var startWaitTime : float = 2.85
@export var expoDiffScaling : float = 1.1
@export var minDelay : float = 2.7

@export var addedScaling := 0.15
@export var reducedMinimumDelay := 0.2
@export var reducedMaxDelay := 0.1

# Private Variables
var spawnDelay : float
var spawnedEnemies : int
var gameTime : float
var mobs : Array[Node]
var wave : int
var newWaitTime : float

var canSpawn := true

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnDelay = startWaitTime
	newWaitTime = startWaitTime
	mobs = get_children()
	#print(mobs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spawn_timer_timeout():
	if not canSpawn: return
	
	spawnedEnemies = mobs.size() - 2
	print("Zombies: ", mobs.size() - 2)
	
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
		player.playaudio(true)
	elif distanceFromPlayer.x >= 0:
		player.playaudio(false)
	elif distanceFromPlayer.x <= -128:
		player.playaudio(false)
	elif distanceFromPlayer.x <= 0:
		player.playaudio(true)
	
	# Spawn the mob by adding it to the Spawner scene.
	add_child(_mob)
	move_child(_mob, 0)
	mobs = get_children()
	#print(mobs)
	
	
	if spawnedEnemies >= 9:
		spawnedEnemies = 9
	spawnDelay -= 0.1 - (0.03 * spawnedEnemies)
	
	if spawnDelay <= 1:
		spawnDelay = 1
	
	$SpawnTimer.wait_time = spawnDelay
	
	#if minDelay <= 0:
		#minDelay = 1
	#elif spawnDelay >= minDelay:
		#spawnDelay = spawnDelay - 0.05 * (expoDiffScaling**(spawnedEnemies / spawnDelay))
		#print("Time reduced by: " , 0.05 * (expoDiffScaling**(spawnedEnemies / spawnDelay)))
	#else:
		#$SpawnTimer.wait_time = minDelay
		#
		#spawnDelay = newWaitTime
		#expoDiffScaling += addedScaling
		#minDelay -= reducedMinimumDelay
		##spawnedEnemies = 0
		#wave = wave + 1
		#if (int(wave)%5) == 00:
			#newWaitTime -= reducedMaxDelay
			#startWaitTime = newWaitTime
		#print("Max Wait Time: ", newWaitTime, " New Spawn Delay: ", spawnDelay, " New Difficulty Multiplier: ", expoDiffScaling, " New Min Delay: ", minDelay, " Wave: ", wave)
		#
	#
	#
	#if spawnDelay > 1:
		#if spawnDelay <= minDelay:
			#$SpawnTimer.wait_time = minDelay
		#elif spawnDelay >= minDelay:
			#$SpawnTimer.wait_time = spawnDelay
	#else:
		#spawnDelay = 1
		#minDelay = 1
		#$SpawnTimer.wait_time = 1
	
	
	
	print("Spawn Delay: " , spawnDelay)
	

func dead():
	canSpawn = false
	var i : int
	for m in mobs:
		m.process_mode = Node.PROCESS_MODE_DISABLED

