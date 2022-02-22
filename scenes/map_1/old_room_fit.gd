tool
extends "res://scenes/base_map/base_map.gd"

#rooms will be have dimensions within (inclusive) these dimensions
export var min_room_size = Vector2(5, 4)
export var max_room_size = Vector2(14, 11)

#amount of space bettween rooms and outer map wall
export var wall_buffer = 2
export var room_buffer = 2
export var attempts = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	#gen map on start
	_gen_map()
	

func _input(event):
	#gen map on enter key
	if event.is_action_pressed("ui_accept"):
		_gen_map()

#reset and generate new map layout in Tilemap
func _gen_map():
	
	#gen 2d array of wall-tile-IDs as initial map
	var layout_array = _gen_init_map_array()	
	#gen vector2-indexed dict mapping posiitons to valid room radii at that position
	var constraints = _gen_init_constraints()
	
	for _i in range(attempts):		
		#print number of positions that could be a room centre
		print(constraints.size())		
		if constraints.size() > 0:
		
			var select_pos = get_random_key(constraints) #pick random valid position
			var select_dimensions = get_random_key(constraints[select_pos]) #pick random valid dimensions for that position
			
			#add room to array, update constraints dict
			_gen_room(select_pos, select_dimensions, layout_array, constraints)
			
			#set room center to red tile
			layout_array[select_pos.y][select_pos.x] = 2
			
		else:
			print("no valid positions")
			break
		
	#loop over array of tile IDs and set pos in tile-map to tile
	for pos in all_map_pos:
		$TileMap.set_cellv(pos, layout_array[pos.y][pos.x])


#add room of empty tiles to given 'array' and update given 'constraints' accordingly
func _gen_room(pos, radius_dimensions, array, constraints):
	
	#set all tiles within room dimensions to empty
	for y in range(pos.y - radius_dimensions.y, pos.y + radius_dimensions.y + 1):
		for x in range(pos.x - radius_dimensions.x, pos.x + radius_dimensions.x + 1):
			array[y][x] = -1
	
	
	##------------ CONSTRAINTS-UPDATE -----------------##
	
	#hold new room-rect coords (incl buffers)
	var new_top_left = Vector2(pos.x - radius_dimensions.x - room_buffer - 1, pos.y - radius_dimensions.y - room_buffer - 1)
	var new_bottom_right = Vector2(pos.x + radius_dimensions.x + room_buffer + 1, pos.y + radius_dimensions.y + room_buffer + 1)
	
	var to_invalid = [] #array to hold newly invalid posiitons
	
	for c_pos in constraints:
		var to_remove = [] #array to hold newly invalid dimensions
		
		for dimension in constraints[c_pos]:
			#hold old room-rect coords (NOT incl buffers)
			var old_top_left = Vector2(c_pos.x - dimension.x, c_pos.y - dimension.y)
			var old_bottom_right = Vector2(c_pos.x + dimension.x, c_pos.y + dimension.y)
			
			#clever check to see if new and old room-rects overlap
			if (new_top_left.x < old_bottom_right.x and new_bottom_right.x > old_top_left.x and
			new_top_left.y < old_bottom_right.y and new_bottom_right.y > old_top_left.y):
				to_remove.append(dimension) #invalid dimension
				
		#remove invalid dimensions
		for dimension in to_remove:
			constraints[c_pos].erase(dimension)
		
		if constraints[c_pos].size() == 0:
			to_invalid.append(c_pos) #position has no possible valid rooms
	
	#remove invalid positions
	for d_pos in to_invalid:
		constraints.erase(d_pos)
		


func _gen_init_constraints():
	var constraints = {}
	
	for pos in all_map_pos:
		#largest x-radius that can fit on map from pos
		var max_x = min(pos.x - wall_buffer,
					map_dimensions.x - 1 - pos.x - wall_buffer)
		#largest y-radius that can fit on map from pos
		var max_y = min(pos.y - wall_buffer,
					map_dimensions.y - 1 - pos.y - wall_buffer)
		
		var this_constraint = {}
		
		#loop through all valid y dimensions
		for y in range(min_room_size.y, min(max_y, max_room_size.y) + 1):
			#loop through all valid x dimensions
			for x in range(min_room_size.x, min(max_x, max_room_size.x) + 1):
				this_constraint[Vector2(x, y)] = true #add this dimension as valid
		
		if this_constraint.size() > 0: #if dimensions exist, add point
			constraints[pos] = this_constraint
	
	return constraints
		

#gen 2d array of wall-tile-ID's (1)
func _gen_init_map_array():
	var array = []
	for y in int(map_dimensions.y):
		array.append([])
		for x in int(map_dimensions.x):
			array[y].append(1)
				
	return array
	

#return random key from given dict 'dict'
func get_random_key(dict):
   var a = dict.keys()
   a = a[randi() % a.size()]
   return a
