extends Node

## Public Variables
# hehe zom-b 
@export var zomb : PackedScene
@export var startWaitTime : float = 2.85

## Old difficulty setting stuff...
#@export var expoDiffScaling : float = 1.1
#@export var minDelay : float = 2.7
#@export var addedScaling := 0.15
#@export var reducedMinimumDelay := 0.2
#@export var reducedMaxDelay := 0.1

## Private Variables
var spawnDelay : float
var spawnedEnemies : int
var gameTime : float
var mobs : Array[Node]
var wave : int

var _mobSpawn

#var newWaitTime : float

var canSpawn := true

## Called when the node enters the scene tree for the first time.
func _ready():
	
	spawnDelay = startWaitTime
	mobs = get_children()
	#newWaitTime = startWaitTime
	_mobSpawn = get_node("SpawnPath/SpawnLocation")
	$SpawnTimer.wait_time = spawnDelay
	$SpawnTimer.start()
	
	var _mob = zomb.instantiate()
	
	## Choose a random location on the SpawnPath.
	## We store the reference to the SpawnLocation node.
	_mobSpawn = get_node("SpawnPath/SpawnLocation")
	## And give it a random offset.
	_mobSpawn.progress_ratio = randf()
	
	## I should probably just assign this as a private variable in _ready
	var player = $"../PlayerScene"
	_mob.initialize(_mobSpawn.position, player.position)
	
	## Spawn the mob by adding it to the Spawner scene.
	add_child(_mob)
	## New zombie won't appear "in front" of closer ones
	#move_child(_mob, 0)
	mobs = get_children()


func _on_spawn_timer_timeout():
	if not canSpawn: return
	
	spawnedEnemies = mobs.size() - 2
	print("Zombies: ", mobs.size() - 2)
	
	## Create a new instance of the Mob scene.
	var _mob = zomb.instantiate()
	
	## Choose a random location on the SpawnPath.
	## We store the reference to the SpawnLocation node.
	_mobSpawn = get_node("SpawnPath/SpawnLocation")
	## And give it a random offset.
	_mobSpawn.progress_ratio = randf()
	
	## I should probably just assign this as a private variable in _ready
	var player = $"../PlayerScene"
	_mob.initialize(_mobSpawn.position, player.position)
	
	## Spawn the mob by adding it to the Spawner scene.
	add_child(_mob)
	## New zombie won't appear "in front" of closer ones
	#move_child(_mob, get_child_count()+1)
	_mob.set_deferred("z_index", -mobs.size() - 200)
	mobs = get_children()
	#print(mobs)
	
	## New and simplified difficulty settings, found out it didn't have to be extremely complicated
	if spawnedEnemies >= 9:
		## Basically slows down or increases delay when there are enough zombies on the level
		## I have not yet experienced having more than 5 and surviving, but maybe it's possible idk
		spawnedEnemies = 9
	## idk i just put in some numbers after a minimal amount of testing
	spawnDelay -= 0.15 - (0.025 * spawnedEnemies) 
	
	## Minimum delay is hard coded I know 
	if spawnDelay <= 0.9:
		spawnDelay = 0.9
	
	$SpawnTimer.wait_time = spawnDelay
	
	## SPARE YOUR SANITY, DO NOT READ (OR ACTIVATE) ANY OF THIS CODE
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
		#spawnedEnemies = 0
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
	

## disable spawning and all mobs if the player is dead. Mercy rule you know
func dead():
	canSpawn = false
	for m in mobs:
		if is_instance_valid(m):
			m.process_mode = Node.PROCESS_MODE_DISABLED

