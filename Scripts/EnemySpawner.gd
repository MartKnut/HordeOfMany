extends Node2D

var spawnpoint1 : Node2D
var spawnpoint2 : Node2D
var spawnpoint3 : Node2D
var spawnpoint4 : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnpoint1 = $"1"
	spawnpoint2 = $"2"
	spawnpoint3 = $"3"
	spawnpoint4 = $"4"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
