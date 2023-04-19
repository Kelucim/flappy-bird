extends RigidBody2D

@export var jump_height = -1000
signal new_score
signal died
var can_rotate = false

var can_jump = true

func _ready():
	$AnimatedSprite2D.play("default")

func _process(_delta):	
	if position.y <= -300 && can_jump:
		_player_died()
	print_debug(rotation_degrees)
	if linear_velocity.y > 0 && can_rotate:
		var tween = get_tree().create_tween().set_parallel(true)
		
		tween.tween_property($AnimatedSprite2D, "rotation_degrees", 30, 1)
		tween.tween_property($Death, "rotation_degrees", 30, 1)
		
	if !can_rotate && $AnimatedSprite2D.rotation_degrees != 0:
		var reset_tween = get_tree().create_tween().set_parallel(true)
		
		reset_tween.tween_property($AnimatedSprite2D, "rotation_degrees", 0, 0.5)
		reset_tween.tween_property($Death, "rotation_degrees", 0, 0.5)
	
func _on_area_2d_area_entered(_area):
	new_score.emit()

func _on_death_area_entered(_area):
	_player_died()
	
func _start():
	_jump()
	$Area2D/ScoreCollision.disabled = false
	$Death/DeathCollision.disabled = false
	can_jump = true
	can_rotate = true

func _player_died():
	died.emit()
	can_rotate = false
	$Area2D/ScoreCollision.set_deferred("disabled", true)
	$Death/DeathCollision.set_deferred("disabled", true)
	can_jump = false
	$AnimatedSprite2D.rotation_degrees = 0
	$Death.rotation_degrees = 0
	linear_velocity.y = -500

func _input(event):
	if Input.is_action_just_pressed("jump_input") && can_jump:
		_jump()
		
	if event is InputEventScreenTouch:
		if event.is_pressed() && can_jump:
			_jump()

func _jump():
	linear_velocity.y = jump_height

	var tween = get_tree().create_tween().set_parallel(true)

	tween.tween_property($AnimatedSprite2D, "rotation_degrees", -30, 0.5)
	tween.tween_property($Death, "rotation_degrees", -30, 0.5)

