extends Control

func _ready():
	if PlayerStats.health == 0:
		completed_game()

func completed_game():
	visible = true

func _on_Restart2_pressed():
	get_tree().change_scene("res://World.tscn")
	visible = false

func _on_Quit2_pressed():
	get_tree().quit()
	visible = false
