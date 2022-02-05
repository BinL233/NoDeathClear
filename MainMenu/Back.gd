extends Control





func _on_Button_pressed():
	#get_node("/Mainmenu/Buttons").visible = true #show the main menu buttons
	get_parent().visible = false #hide the current menu
	
	if get_parent().name == "Controls":
		SceneChanger.change_scene("res://MainMenu/Mainmenu.tscn")

