extends ParallaxBackground

var he_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !he_dead:
		scroll_offset.x -= 350 * delta
