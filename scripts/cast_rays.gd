extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dungeon = get_parent()
	var tile_map = get_node("../TileMap")
	#dungeon.deselect_tiles()
	var units = 4
	rotation = 0
	for i in range(units):
		rotation += (((2*PI)/units)*i)
		if $Ray.is_colliding():
			var pos = $Ray.get_collision_point()
			tile_map.set_cellv((pos - $Ray.get_collision_normal()) / 64, 2)
		
