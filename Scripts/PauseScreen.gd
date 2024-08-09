extends Control


var pauseLabel : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pauseLabel = $Label

# V  no it's not  V
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var pausePressed = Input.is_action_just_pressed("Pause")
	if pausePressed:
		_pause()

func _pause():
	visible = !visible
	# Get all stuff in the game and pause it
	get_tree().paused = !get_tree().paused

# this is what makes the || blink :)
func _on_timer_timeout():
	pauseLabel.visible = !pauseLabel.visible
