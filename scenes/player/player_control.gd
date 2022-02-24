extends Area2D


export var tile_dimensions = Vector2(32, 32)
export var move_speed = 6;


var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}


func _ready():
	position = position.snapped(tile_dimensions / 2)


func _process(_delta):

	if $Tween.is_active():
		return
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			move(inputs[dir])



func _unhandled_input(event):
	if $Tween.is_active():
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(inputs[dir])


func move(dir):
	$CollisionRay.cast_to = dir * tile_dimensions
	$CollisionRay.force_raycast_update()
	if not $CollisionRay.is_colliding():
		move_tween(dir)
		

func move_tween(dir):
	$Tween.interpolate_property(self, "position",
		position, position + dir * tile_dimensions,
		1.0/move_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
