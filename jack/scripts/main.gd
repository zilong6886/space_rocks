extends Node2D

onready var spawns = $spawn_locations
onready var asteroid_container = $asteroid_container
onready var expl_sounds = $expl_sounds

var break_pattern = {
	'big': 'med',
	'med': 'sm',
	'sm': 'tiny',
	'tiny': null
}
var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")


func _ready():
	for i in range(1):
		spawn_asteroid("big", spawns.get_child(i).position, Vector2.ZERO)
	set_process(true)
	$music.play()
	
func _process(delta):
	if asteroid_container.get_child_count() == 0:
		for i in range(2):
			spawn_asteroid("big", spawns.get_child(i).position, Vector2.ZERO)
		

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset
			var newvel = vel + hit_vel.tangent() * offset
			spawn_asteroid(newsize, newpos, newvel)	
	var expl = explosion.instance()
	expl.position = pos
	add_child(expl)
	expl.play()
	expl_sounds.play()
