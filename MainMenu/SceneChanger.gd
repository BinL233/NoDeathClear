extends CanvasLayer


onready var animator = $AnimationPlayer
onready var color = $ColorRect

func change_scene(path):
	color.show()
	animator.play("Scenechange")
	yield(animator, "animation_finished")
	get_tree().change_scene(path)
	animator.play_backwards("Scenechange")
	yield(animator, "animation_finished")
	color.hide()
