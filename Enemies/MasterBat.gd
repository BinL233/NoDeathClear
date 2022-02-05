extends KinematicBody2D
signal health_changed



const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
var float_text = preload("res://UI/Float.tscn")
const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const BGM1 = preload("res://Music and Sounds/BGM1.tscn")
var float_plus1_text = preload("res://UI/Float+1.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 45
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4


enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO

var knockback = Vector2.ZERO

var state = CHASE

var seek = false



onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $Softcollsion
onready var wanderController = $WanderController
onready var blinkAnimation = $BlinkAnimation
onready var battleBGM1 = $BattleBGM1

func _ready():
	state = pick_random_state([IDLE, WANDER])
	emit_signal('health_changed', stats.health * 100/ stats.max_health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * 0.5 * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
				
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				state = pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
			
		CHASE:

			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)


				
			else:
				state = IDLE
				battleBGM1.stop()

				
				


	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400			
	velocity = move_and_slide(velocity)
	
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
	sprite.flip_h = velocity.x < 0
				
			
func seek_player():
	if playerDetectionZone.can_see_player():		
		battleBGM1.play()
		seek = true
		
		
		state = CHASE

		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	emit_signal('health_changed', stats.health * 100/ stats.max_health)
	knockback = area.knockback_vector * 55
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
	var ft = float_text.instance()
	ft.position = Vector2(10, -10)
	ft.velocity = Vector2(rand_range(-15,15), -10)
	ft.gravity = Vector2(0, 1)
	ft.mass = 100
	ft.modulate = Color(rand_range(0.85, 0.85), rand_range(0.5,0.5), rand_range(0.8,0.8), 1)
	
	add_child(ft)
	
	print(stats.health)
	


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	SceneChanger.change_scene("res://UI/GameWin.tscn")


func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")





func _on_ShadowTimer_timeout():
	if seek == false:
		emit_signal('health_changed', stats.health * 100/ stats.max_health)
		
	if seek == true:
		if stats.health <= stats.max_health:
		
			stats.health += 2
			emit_signal('health_changed', stats.health * 100/ stats.max_health)
			var ft = float_plus1_text.instance()
			ft.position = Vector2(10, -10)
			ft.velocity = Vector2(rand_range(-15,15), -10)
			ft.gravity = Vector2(0, -1)
			ft.mass = 100
			ft.modulate = Color(rand_range(0.35, 0.35), rand_range(0.9,0.9), rand_range(0.4,0.4), 1)
				
			add_child(ft)
			
		else:
			emit_signal('health_changed', stats.health * 100/ stats.max_health)
		
