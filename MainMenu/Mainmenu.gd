extends Control

#grab focus on the start button for keyboard input
func _ready():
	get_node("Buttons/Start Game").grab_focus()
	$AudioStreamPlayer.play()

func _on_Start_Game_pressed():
	$Buttons.visible = false
	SceneChanger.change_scene("res://World.tscn")

func _on_Controls_pressed():
	SceneChanger.change_scene("res://MainMenu/Controls.tscn")

func _on_Quit_to_Desktop_pressed():
	get_tree().quit()
