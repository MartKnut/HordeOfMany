extends Node2D

var gameManager

@export var scoreText : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = $"../../GameManager"

func _process(delta):
	scoreText.text = str(gameManager.score)

func dead():
	$Dead.visible = true
