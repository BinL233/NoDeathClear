extends Position2D

var text setget set_text, get_text
var velocity = Vector2.ZERO
var gravity = Vector2.ZERO
var mass = 100

func _ready():
	$Tween.interpolate_property(self, "modulate", 
	Color(modulate.r, modulate.g, modulate.b, modulate.a),
	Color(modulate.r, modulate.g, modulate.b, 0),
	0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7
	)
	
	$Tween.interpolate_property(self, "scale", 
	Vector2(0, 0),
	Vector2(1, 1),
	0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	
	$Tween.interpolate_property(self, "scale", 
	Vector2(1, 1),
	Vector2(0.6, 0.6),
	0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7
	)
	
	$Tween.start()
	

func _process(delta):
	velocity += gravity * mass * delta
	position += velocity * delta

func set_text(txt):
	$Label.text = str(txt)
	
func get_text():
	return $Label.text


func _on_Tween_tween_all_completed():
	get_tree().queue_delete(self)
