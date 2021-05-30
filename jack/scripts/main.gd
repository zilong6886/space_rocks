extends Node2D

onready var spawns = $spawn_locations
onready var asteroid_container = $asteroid_container
onready var expl_sounds = $expl_sounds
onready var shield_bar = $HUD.get_node("shield_bar")
onready var player = $player
onready var score = $HUD.get_node("score")

var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")


func _ready():	
	set_process(true)
	$music.play()
	
func show_hud_field():
	var shield_level = player.shield_level
	var color = "green"
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	var texture = load("res://assets/art/gui/barHorizontal_%s_mid 200.png" % color)
	shield_bar.texture_progress = texture
	shield_bar.value = shield_level
	
func _process(delta):
	show_hud_field()
	score.set_text(str(globals.score))
	if asteroid_container.get_child_count() == 0:
		globals.level += 1
		for i in range(globals.level):
			spawn_asteroid("big", spawns.get_child(i).position, Vector2.ZERO)
		

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
