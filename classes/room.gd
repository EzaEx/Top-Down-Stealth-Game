extends Node


var top_left
var bottom_right
var margin = 0


func _init(tl, br, mar):
	top_left = tl
	bottom_right = br
	margin = mar


func get_centre():	
	return top_left + (bottom_right - top_left) / 2


func get_layout():
	var layout = {}
	for y in range(top_left.y, bottom_right.y + 1):
		for x in range(top_left.x, bottom_right.x + 1):
			var coords = Vector2(x, y)
#			if (y == top_left.y or y == bottom_right.y or
#				x == top_left.x or x == bottom_right.x):
#				if (y == int(get_centre().y) or x == int(get_centre().x)):
#					#potential door
#					layout[coords] = 1
#				else:
#					#wall
#					layout[coords] = 1
			#else:
				#floor
			layout[coords] = 0
	
	return layout


func intersects(room):
	#clever check to see if given and this room-rects overlap
	if (room.top_left.x - margin < bottom_right.x and room.bottom_right.x + margin > top_left.x and
	room.top_left.y - margin < bottom_right.y and room.bottom_right.y + margin > top_left.y):
		return true
	
	return false
	

func neighbors(cmp_room, rooms):
	var this_c = get_centre()
	var cmp_c = cmp_room.get_centre()
	var distance = (cmp_c - this_c).length()
	for room in rooms:
		var room_c = room.get_centre()
		if room_c == this_c or room_c == cmp_c:
			continue
		if ((room_c - this_c).length() < distance and
			(room_c - cmp_c).length() < distance):
			return false
	return true
		
