extends PathFollow2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func move(delta, speed):
	offset += speed * delta
