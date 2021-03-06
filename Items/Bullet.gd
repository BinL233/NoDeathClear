extends Area2D

export (int) var speed
export (int) var damage
export (float) var steer_force = 0

var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	target = _target

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer

func _process(delta):
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta

func explode():
	set_process(false)
	velocity = Vector2()
	$Sprite.hide()
	



func _on_Bullet_area_entered(area):
	explode()
	if area.has_method('take_damage'):
		area.take_damage(damage)
		




func _on_LifeTime_timeout():
	explode()
	

