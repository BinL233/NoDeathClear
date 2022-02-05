extends Sprite
export var cooldown_time = 1
var isRun = false
var Show = false





func _ready():
	$Label.hide()
	$TextureProgress.value = 0
	$TextureProgress.texture_progress = texture
	$Timer.wait_time = cooldown_time
	set_process(false)

	
func _process(delta):
	$Label.text = "%0.1f" % $Timer.time_left
	$TextureProgress.value = int(($Timer.time_left / cooldown_time) * 100)

	

func _on_Timer_timeout():
	isRun = false
	$Label.hide()
	$TextureProgress.value = 0
	set_process(false)
	


func _input(event):
	if Input.is_action_just_pressed("skill_health_up"):
	
		if PlayerStats.health < PlayerStats.max_health:
			if isRun == false:
				Show = true
				isRun = true
				$Label.show()
				$Timer.start()
				set_process(true)
