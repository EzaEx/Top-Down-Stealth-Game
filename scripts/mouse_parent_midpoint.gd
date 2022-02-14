extends Position2D


# Declare member variables here. Examples:
export var player_bias = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport = get_viewport()
	var mouse_point = viewport.get_mouse_position() - viewport.get_visible_rect().size / 2
	
	transform = Transform2D(0, mouse_point * player_bias)
