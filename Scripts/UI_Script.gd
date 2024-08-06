extends Control

# Public Variables
@export var scoreText : Label
@export var finalScoreText : Label

# Private Variables
var gameManager
var gameUI : Control
var deathUI : Control
var textflashTimer : Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	gameUI = $Score
	deathUI = $Dead
	textflashTimer = $Timer
	gameManager = $"../../GameManager"

func _process(delta):
	scoreText.text = str(gameManager.score)
	finalScoreText.text = str("Score: " , gameManager.score)

func dead():
	gameUI.visible = false
	textflashTimer.start()
	deathUI.visible = true
	get_tree().paused = true




func _on_timer_timeout():
	deathUI.get_child(0).visible = !deathUI.get_child(0).visible


func _on_menu_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Start_Scene.tscn")
