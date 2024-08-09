extends Node

@export var score := 0

# I don't even know why I have a game manager when this is all it does.
# or maybe I don't know why I didn't use it for more? I forgot which one it was..
func increaseScore():
	score += 1
