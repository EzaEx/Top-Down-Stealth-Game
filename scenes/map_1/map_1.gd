tool
extends "res://scenes/base_map/base_map.gd"

const Room = preload("res://classes/room.gd")
const neighbor_poses = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]

export var room_count = 20
export var room_margin = 1
export var edge_margin = 5
export var generative = true
export var gen_corridors = true
export var from_last = false
export var placement_attempts = 1
export var min_shot_angle = 0
export var max_shot_angle = 2*PI

#limits of room dimensions (not including walls)
export var min_dimensions = Vector2(3, 2)
export var max_dimensions = Vector2(10, 7)

var all_dimensions

# Called when the node enters the scene tree for the first time.
func _ready():
	#increase to account for walls
	if generative:
		_generate()
	


func _generate():
	randomize()
	all_dimensions = []
	var poss_dims = []
	for y in range(min_dimensions.y, max_dimensions.y + 1):
		for x in range(min_dimensions.x, max_dimensions.x + 1):
			if x / y > 2 or y / x > 2:
				pass #invalid
			else:
				if y * x < rand_range(min_dimensions.x * min_dimensions.y, 0.75 * max_dimensions.x * max_dimensions.y):
					var dimension = Vector2(x, y)
					poss_dims.append(dimension)
					
	for i in range(room_count / 10):
		all_dimensions.append(_rand_el(poss_dims))
	
	all_dimensions.append(Vector2(30, 30))
	
	for i in range(room_count * 3 / 10):
		all_dimensions.append(_rand_el(poss_dims))
		
	all_dimensions.append(Vector2(35, 20))
		
	for i in range(room_count * 3 / 10):
		all_dimensions.append(_rand_el(poss_dims))
		
	all_dimensions.append(Vector2(15, 40))
		
	for i in range(room_count * 3 / 10):
		all_dimensions.append(_rand_el(poss_dims))
	
	clear_layout()
	_gen_layout()


func _gen_layout():
	
	var all_rooms = []
	
	
	#generate rooms
	for i in room_count:
		var direction = 0
		var dimensions = all_dimensions[i]
		var pos_rooms = []
		
		for attempt in placement_attempts:
			var fit_in = false

			var current_pos = Vector2.ZERO
			if from_last and all_rooms.size() > 0:
				current_pos = all_rooms[-1].get_centre()
				
			direction = Vector2.RIGHT.rotated(rand_range(min_shot_angle, max_shot_angle))
			while not fit_in:
				var top_l = Vector2(int(current_pos.x), int(current_pos.y))
				var btm_r = top_l + dimensions - Vector2.ONE
				var margin = room_margin
				var new_room = Room.new(top_l, btm_r, margin)
				
				fit_in = true
				for existing_room in all_rooms:
					if existing_room.intersects(new_room):
						fit_in = false
						break
						
				if fit_in:
					pos_rooms.append(new_room)
					break
					
				current_pos += direction
				
		var winner = pos_rooms[0]
		for candidate in pos_rooms:
			if candidate.get_centre().length() < winner.get_centre().length():
				winner = candidate
		
		all_rooms.append(winner)
	
	#draw room bases
	for room in all_rooms:
		var tiles = room.get_layout()
		for pos in tiles:
			$TileMap.set_cellv(pos, tiles[pos])

	#find/draw corridor bases
	for i in all_rooms.size():
		var this_room = all_rooms[i]
		
		for j in range(i + 1, all_rooms.size()):
			var that_room = all_rooms[j]
			
			if this_room.neighbors(that_room, all_rooms):
				
				if gen_corridors:
					#make corridor
					var that_c = that_room.get_centre()
					var this_c = this_room.get_centre()
					
					that_c = Vector2(int(that_c.x), int(that_c.y))
					this_c = Vector2(int(this_c.x), int(this_c.y))
					
					var ydir = 1
					if this_c.y < that_c.y:
						ydir = -1
									
					var hold_y = that_c.y
					for y in range(that_c.y, this_c.y + ydir, ydir):
						$TileMap.set_cell(that_c.x, y, 0)
						$TileMap.set_cell(that_c.x + 1, y, 0)
						hold_y = y
					
					var xdir = 1
					if this_c.x < that_c.x:
						xdir = -1
					
					for x in range(that_c.x, this_c.x + xdir, xdir):
						$TileMap.set_cell(x, hold_y, 0)
						$TileMap.set_cell(x, hold_y - ydir, 0)
					
				else: #no corridors, just draw graph edges
					var path_line = Line2D.new()
					path_line.width = 30
					path_line.default_color = Color(0, 0, 255)
					path_line.points = PoolVector2Array([that_room.get_centre() * 32, this_room.get_centre() * 32])
					$Lines.add_child(path_line)
	
	#draw walls
	var rec = $TileMap.get_used_rect()
	rec.position -= Vector2.ONE * edge_margin
	rec.size += Vector2.ONE * edge_margin * 2
	for y in range(rec.position.y, rec.position.y + rec.size.y):
		for x in range(rec.position.x, rec.position.x + rec.size.x):
			if $TileMap.get_cell(x, y) == -1:
				$TileMap.set_cell(x, y, 1)
	
	#apply autowall
	$TileMap.update_bitmask_region(rec.position, rec.position + rec.size)
	
func _rand_el(list):
	return list[randi() % list.size()]
