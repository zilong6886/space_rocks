extends Node2D

onready var spawns = $spawn_locations
onready var asteroid_container = $asteroid_container
onready var expl_sounds = $expl_sounds
onready var player_expl_sounds = $player_expl_sounds
onready var player = $player
onready var HUD = $HUD

var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")

func _ready():	
	set_process(true)
	$music.play()
	begin_next_level()
	player.connect("explode", self, "explode_player")
	
func begin_next_level():
	globals.level += 1
	HUD.show_message("Wave %s" % globals.level)
	for i in range(globals.level):
		spawn_asteroid("big", spawns.get_child(i).position, Vector2.ZERO)
	
func _process(delta):
	HUD.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level()

func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)

func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = globals.break_pattern[size]
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

func explode_player():
	player.disable()
	var expl = explosion.instance()
	add_child(expl)
	expl.scale = Vector2(1.5, 1.5)
	expl.position = player.position
	expl.animation = "sonic"
	expl.play()
	player_expl_sounds.play()
	HUD.show_message("Game Over")
	$restart_timer.start()


func _on_restart_timer_timeout():
	globals.new_game()
