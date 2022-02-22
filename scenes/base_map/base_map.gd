tool
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

#clears and resets the map to current dimensions
func clear_layout():
	#clear existing tilemaps
	$TileMap.clear()
		

		
func _old_code():
	#draw occluders for all vent tiles
#	for map_coord in all_map_pos:
#		if $TileMap.get_cellv(map_coord) == 3:
#			var world_coords = $TileMap.map_to_world(map_coord)
#			var new_occluder = LightOccluder2D.new()
#			var new_occluder_poly = OccluderPolygon2D.new()
#
#			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(0, 0), 
#			world_coords + Vector2(0, 16), 
#			world_coords + Vector2(4, 16), 
#			world_coords + Vector2(4, 0)])				
#			new_occluder.occluder = new_occluder_poly
#			$CutomOccluders.add_child(new_occluder)
#
#
#			new_occluder = LightOccluder2D.new()
#			new_occluder_poly = OccluderPolygon2D.new()
#			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(12, 0), 
#			world_coords + Vector2(12, 16), 
#			world_coords + Vector2(20, 16), 
#			world_coords + Vector2(20, 0)])				
#			new_occluder.occluder = new_occluder_poly
#			$CutomOccluders.add_child(new_occluder)
#
#
#			new_occluder = LightOccluder2D.new()
#			new_occluder_poly = OccluderPolygon2D.new()
#			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(32, 0), 
#			world_coords + Vector2(32, 16), 
#			world_coords + Vector2(28, 16), 
#			world_coords + Vector2(28, 0)])				
#			new_occluder.occluder = new_occluder_poly
#			$CutomOccluders.add_child(new_occluder)
	pass
