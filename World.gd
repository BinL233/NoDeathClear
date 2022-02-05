extends Node2D



const BGM1 = preload("res://Music and Sounds/BGM1.tscn")

func _ready():
	var bGM1 = BGM1.instance()
	get_tree().current_scene.add_child(bGM1)
