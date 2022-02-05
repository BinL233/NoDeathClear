extends Node2D

var stats = preload("res://Stats.tscn")


func _ready():
	for node in get_children():
		node.hide()

func _process(delta):
	global_rotation = 0



func _on_MasterBat_health_changed(value):
	if value < 100:
		$bar.show()
	$bar.value = value
