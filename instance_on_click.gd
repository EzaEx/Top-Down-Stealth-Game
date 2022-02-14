extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var to_instance

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("left_click"):
		var obj = to_instance.instance()
		obj.position = get_global_mouse_position()
		add_child(obj)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
