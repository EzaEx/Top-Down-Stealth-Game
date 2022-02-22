extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
export var bounce_limit = 4
export var path_length = 20

var velocity = Vector2(0, 0)
var bounces = 0
var distance_travelled = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(speed, 0).rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var next_step = global_position + (velocity * delta)
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, next_step, [], 2)
	
	if result: # bounced
		#add normal to ensure particle not in collided tile
		var new_location = result.position + result.normal
		distance_travelled += (global_position - new_location).length()
		global_position = new_location
		bounces += 1
		if bounces > bounce_limit:
			queue_free()
			return

		velocity = velocity.bounce(result.normal)
	
	else: #no bounce
		position += (velocity * delta)
		distance_travelled += (velocity * delta).length()
		
	$Trail.global_transform = Transform2D.IDENTITY
	$Trail.points = PoolVector2Array([global_position] + _gen_trail_points(global_position, PI + velocity.angle(), min(path_length, distance_travelled)))

func _gen_trail_points(origin, heading_angle, length):
	
	var space_state = get_world_2d().direct_space_state
	var dest_point = origin + Vector2.RIGHT.rotated(heading_angle) * length
	var result = space_state.intersect_ray(origin, dest_point, [], 2)
	if not result: #no bounce
		return [dest_point]
	else: #bounce:
		heading_angle = (dest_point - origin).bounce(result.normal).angle()
		length -= (result.position - origin).length()
		origin = result.position + result.normal
		return [result.position] + _gen_trail_points(origin, heading_angle, length)
	
	
	
