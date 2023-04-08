extends RigidBody2D

@export var jump_height = -1000
signal new_score
signal died

var can_jump = true

func _ready():
	$AnimatedSprite2D.play("default")

func _process(_delta):	
	if position.y <= -300 && can_jump:
		_player_died()
	
func _on_area_2d_area_entered(_area):
	new_score.emit()

func _on_death_area_entered(_area):
	_player_died()
	
func _start():
	$Area2D/ScoreCollision.disabled = false
	$Death/DeathCollision.disabled = false
	can_jump = true

func _player_died():
	died.emit()
	$Area2D/ScoreCollision.set_deferred("disabled", true)
	$Death/DeathCollision.set_deferred("disabled", true)
	can_jump = false
	linear_velocity.y = -500

func _input(event):
	if Input.is_action_just_pressed("jump_input") && can_jump:
		linear_velocity.y = jump_height
		
	if event is InputEventScreenTouch:
		if event.is_pressed() && can_jump:
			linear_velocity.y = jump_height
