extends Control

func _ready():
	$AudioStreamPlayer.play()
	GlobalTextureButton.visible = false
	TextureButton2.visible = false

func _on_Restart2_pressed():
	PlayerStats.health += 5
	SceneChanger.change_scene("res://World.tscn")


func _on_Quit2_pressed():
	get_tree().quit()
