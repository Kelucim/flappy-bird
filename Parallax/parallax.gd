extends ParallaxBackground

var not_dead = true

func _process(delta):
	if not_dead:
		scroll_offset.x -= 360 * delta

func _he_died():
	not_dead = !not_dead
