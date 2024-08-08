extends Control

func _on_play_button_down():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property($"../Sky", "position", Vector2(0, -64), 1)
	tween2.tween_property($"../256x64", "position", Vector2(0, 0), 1)
	
	$Timer.start()
	

func _on_github_button_down():
	OS.shell_open("https://github.com/MartKnut/HordeOfMany")

func _on_timer_timeout():
	print("finished animation")
	get_tree().change_scene_to_file("res://Scenes/Game_Scene.tscn")
	
	
