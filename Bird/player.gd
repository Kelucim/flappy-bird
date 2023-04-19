extends RigidBody2D

@export var jump_height = -1000
signal new_score
signal died
var can_rotate = false

var can_jump = false

func _ready():
	$AnimatedSprite2D.play("default")

func _process(_delta):	
	if position.y <= -300 && can_jump:
		_player_died()

#	if linear_velocity.y > 0 && can_rotate:
#		var tween = get_tree().create_tween().set_parallel(true)
#
#		tween.tween_property($AnimatedSprite2D, "rotation_degrees", 30, 1)
#		tween.tween_property($Death, "rotation_degrees", 30, 1)
		
	
func _on_area_2d_area_entered(_area):
	new_score.emit()

func _on_death_area_entered(_area):
	_player_died()
	
func _start():
	_jump()
	$Area2D/ScoreCollision.disabled = false
	$Death/DeathCollision.disabled = false
	can_jump = true


func _player_died():
	died.emit()
	$Area2D/ScoreCollision.set_deferred("disabled", true)
	$Death/DeathCollision.set_deferred("disabled", true)
	can_jump = false
	
	linear_velocity.y = -500	
	
	$Timer.start()
	await $Timer.timeout
	$Timer.start()
	await $Timer.timeout
	$Timer.start()
	await $Timer.timeout
	
	var reset_tween = get_tree().create_tween().set_parallel(true)
	
	reset_tween.tween_property($AnimatedSprite2D, "rotation_degrees", 0, 0.2).set_ease(Tween.EASE_OUT)
	reset_tween.tween_property($Death, "rotation_degrees", 0, 0.2).set_ease(Tween.EASE_OUT)
	

func _input(event):
	if Input.is_action_just_pressed("jump_input") && can_jump:
		_jump()
		
	if event is InputEventScreenTouch && can_jump:
		if event.is_pressed() && can_jump:
			_jump()

func _jump():
	linear_velocity.y = jump_height

	var tween = get_tree().create_tween().set_parallel(true)

	tween.tween_property($AnimatedSprite2D, "rotation_degrees", -30, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property($Death, "rotation_degrees", -30, 0.5).set_ease(Tween.EASE_OUT)
	
	$Timer.start()
	await $Timer.timeout
	
	var tween_2 = get_tree().create_tween().set_parallel(true)
		
	tween_2.tween_property($AnimatedSprite2D, "rotation_degrees", 30, 0.6).set_ease(Tween.EASE_IN)
	tween_2.tween_property($Death, "rotation_degrees", 30, 0.6).set_ease(Tween.EASE_IN)
