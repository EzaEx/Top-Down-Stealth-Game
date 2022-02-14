extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var density = 30
export var particle_speed = 400
export var bounce_limit = 4
export var path_length = 80


# Called when the node enters the scene tree for the first time.
func _ready():

	for i in density:
		var particle = preload("res://Particle.tscn").instance()
		particle.rotation = (2 * PI * i) / density
		particle.speed = particle_speed
		particle.bounce_limit = bounce_limit
		particle.path_length = path_length
		
		add_child(particle)

