extends Control

# cool transition from menu to game
func _on_play_button_down():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property($"../Sky", "position", Vector2(0, -64), 1)
	tween2.tween_property($"../256x64", "position", Vector2(0, 0), 1)
	
	$Timer.start()
	

# if you're reading this, I bet you pressed this button!
func _on_github_button_down():
	OS.shell_open("https://github.com/MartKnut/HordeOfMany")

# I didn't bother finding out if there was a "tween finished" function so I just added a timer
# It switches out the scene once the tween animation is finished
func _on_timer_timeout():
	print("finished animation")
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn")
	
	
