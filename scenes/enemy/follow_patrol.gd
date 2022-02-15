extends KinematicBody2D

export var speed = 200
export(NodePath) var path_point

enum states {PATROL, SPOTTED}
var current_state = states.PATROL

export(NodePath) var player_path
var player

func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(current_state):		
		states.PATROL:
			var follow_point = get_node(path_point)
			follow_point.move(delta, speed)
			var diff_vector = follow_point.position - position
			var movement = diff_vector.normalized() * clamp(speed, 0, diff_vector.length() / delta)  
			$View.rotation = lerp_angle($View.rotation, follow_point.rotation, 20 * delta)
			move_and_slide(movement)
			if check_spotted():
				switch_state(states.SPOTTED)
		
		states.SPOTTED:
			if check_spotted():
				$View.rotation = lerp_angle($View.rotation, (player.position - position).angle(), 20 * delta)
			else:
				switch_state(states.PATROL)


func check_spotted():
	if player in $View/ViewArea.get_overlapping_bodies():
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var result = space_state.intersect_ray(position, player.position)
		return 'player' in result.collider.get_groups()
	return false
	


func switch_state(to_state):
	match(to_state):
		states.PATROL:
			$View/FlashLight.color = Color.white - Color(1, 0.9, 0.2, 0)
			current_state = states.PATROL
		
		states.SPOTTED:
			$View/FlashLight.color = Color.white - Color(1, 0.3, 0.3, 0)
			current_state = states.SPOTTED
