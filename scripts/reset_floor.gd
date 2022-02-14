tool
extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#clear and re-tile floor-map:
	clear()
	for y in get_parent().floor_dimensions.y:
		for x in get_parent().floor_dimensions.x:
			set_cell(x, y, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
