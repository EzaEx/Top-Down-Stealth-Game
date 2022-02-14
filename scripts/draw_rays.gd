extends Position2D


func _ready():
	var map = get_node("../TileMap")
	var occ = map.occluder_light_mask
	print(len(occ))
