extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
var float_text = preload("res://UI/Float.tscn")
var float_plus1_text = preload("res://UI/Float+1.tscn")
var float_plus2_text = preload("res://UI/float +2.tscn")
const healthUpSound = preload("res://Player/HealthUpSound.tscn")
var Bag = preload("res://InventoryContainer.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK,
	HEALTH_UP
}

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats





onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var attackcooldown = $AttackCooldown
onready var blinkAnimation = $BlinkAnimation
onready var rollcooldown = $Rollcooldown
onready var quickmovetime = $Quickmovetime



const MAX_SPEED = 80
const ACCELERATION = 600
const FRICTION = 600
const ROLL_SPEED = 160
const QUICK_SPEED = 200




func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

	

	
	 
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
			
		HEALTH_UP:
			skill_health_up_state(delta)

		
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -  Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	if Input.is_action_just_pressed("roll"):
		#PlayerStats.max_health -= 1 #Health change
		if rollcooldown.is_stopped():
			state = ROLL
			rollcooldown.start()
			TextureButton2.Show = false


	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	
	if GlobalTextureButton.Show == true:

		if attackcooldown.is_stopped():
			state = HEALTH_UP
			attackcooldown.start()
			#var HealthUpSound = healthUpSound.instance()
			#get_tree().current_scene.add_child(HealthUpSound)
			GlobalTextureButton.Show = false

			
		else:
			pass
			
#	if TextureButton2.Show == true:
#		if movecooldown.is_stopped():
#			movecooldown.start()
#			quickmovetime.start()
#			TextureButton2.Show = false
#			velocity = velocity.move_toward(input_vector * QUICK_SPEED, ACCELERATION * delta)
#			print("1")
#			
#		else:
#			pass

		
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func skill_health_up_state(delta):
	
	if PlayerStats.health == PlayerStats.max_health - 1:
		PlayerStats.health += 1
		var ft2 = float_plus2_text.instance()
		ft2.position = Vector2(10, -10)
		ft2.vealocity = Vector2(rand_range(-15,15), -10)
		ft2.gravity = Vector2(0, -1)
		ft2.mass = 100
		ft2.modulate = Color(rand_range(0.35, 0.35), rand_range(0.9,0.9), rand_range(0.4,0.4), 1)
		add_child(ft2)
		
	else:
		PlayerStats.health += 2
		var ft1 = float_plus1_text.instance()
		ft1.position = Vector2(10, -10)
		ft1.velocity = Vector2(rand_range(-15,15), -10)
		ft1.gravity = Vector2(0, -1)
		ft1.mass = 100
		ft1.modulate = Color(rand_range(0.35, 0.35), rand_range(0.9,0.9), rand_range(0.4,0.4), 1)
	
		add_child(ft1)
	

	
	state = MOVE	
	
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE
	
func attack_animation_finished():
	state = MOVE
	
	


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	
	
	var ft = float_text.instance()
	ft.position = Vector2(10, -10)
	ft.velocity = Vector2(rand_range(-15,15), -10)
	ft.gravity = Vector2(0, 1)
	ft.mass = 100
	ft.modulate = Color(rand_range(0.6, 0.6), rand_range(0.6,0.6), rand_range(0.6,0.6), 1)
	
	add_child(ft)
	
	if stats.health == 0:
		
		SceneChanger.change_scene("res://UI/GameComplete.tscn")
		
	
	

func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")


#func _on_Quickmovetime_timeout():
#	var input_vector = Vector2.ZERO
#	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)



