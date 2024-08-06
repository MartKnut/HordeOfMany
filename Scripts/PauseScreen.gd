extends Control


var pauseLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pauseLabel = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pausePressed = Input.is_action_just_pressed("Pause")
	if pausePressed:
		_pause()

func _pause():
	visible = !visible
	get_tree().paused = !get_tree().paused

func _on_timer_timeout():
	pauseLabel.visible = !pauseLabel.visible
