extends Area2D

var teleportable : bool = true
var right : bool
var player : Node
var localposition

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../PlayerScene"
	localposition = position.x
	if position.x <= 64:
		teleportable = true
		right = false
	if position.x >= 192:
		teleportable = true
		right = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if teleportable:
		if not right:
			if player.position.x >= 192:
				position.x = localposition+256
			elif player.position.x >= 0:
				position.x = localposition
		else:
			if player.position.x <= 0:
				position.x = localposition-256
			elif player.position.x <= 192:
				position.x = localposition
	
