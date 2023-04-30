extends CanvasLayer

signal start_game
var score
var not_dead = true
var config = ConfigFile.new()
var high_score = 0

func _ready():
	_load()
	score = 0

func _update_score():
	score += 1
	$Score.text = str(score)
	
func _reset():
	if high_score < score:
		_save()
		high_score = score
		$HighScore.text = "High score: " + str(high_score)
	score = 0
	_he_died()
	$Name.text = "Flappy Bird"
	$Button.show()

func _lost():
	$Name.text = "Game Over!"
	_he_died()
	$Name.show()


func _on_button_pressed():
	start_game.emit()
	$Score.text = str(score)
	$Button.hide()
	$Name.hide()

func _he_died():
	not_dead = !not_dead

func _save():
	config.set_value("Player", "high_score", score)
	
	config.save("user://high_score.cfg")
	
func _load():
	var file_load = config.load("user://high_score.cfg")
	
	if file_load != OK:
		return
	
	high_score = config.get_value("Player", "high_score")
	
	$HighScore.text = "High score: " + str(high_score)
