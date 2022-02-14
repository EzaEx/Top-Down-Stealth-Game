tool
extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var height = get_parent().floor_dimensions.y
	var width = get_parent().floor_dimensions.x
	for y in height:
		for x in width:
			if y == 0 or x == 0 or y == height - 1 or x == width - 1:
				set_cell(x, y, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
