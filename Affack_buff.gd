extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var Time = false
	


func _on_Hurtbox_area_entered(area):
	Hitbox.damage += 9
	$Label.show()
	$Timer.start()
	$Sprite.hide()
	
	if Time == true:
		queue_free()
		
		

func _on_Timer_timeout():
	$Label.hide()
	Time = true
