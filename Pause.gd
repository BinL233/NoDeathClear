extends Control

onready var darkBG = $DarkBG

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
		
func pause_game():
	get_tree().paused = not get_tree().paused
	self.visible = not self.visible
	darkBG.play("StartDark")


func _on_Button_pressed():
	pause_game()
	darkBG.play("StopDark")


func _on_Quit_pressed():
	get_tree().quit()
	
