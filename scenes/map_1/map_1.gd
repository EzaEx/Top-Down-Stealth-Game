tool
extends "res://scenes/base_map/base_map.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	_gen_map()


func _gen_map():
	randomize()
	for pos in all_map_pos:
		if randi() % 10 == 0:
			$TileMap.set_cellv(pos, 2)
