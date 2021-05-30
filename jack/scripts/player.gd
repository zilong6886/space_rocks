extends Area2D

export var rot_speed = 2.6
export var thrust = 500
export var max_vel = 400
export var friction = 0.65

#onready var bullet = preload("res://scenes/player_bullet.tscn")
export(PackedScene) var bullet
onready var bullet_container = $bullet_container
onready var shoot_sounds = $shoot_sounds
onready var nuzzle = $nuzzle
onready var gun_timer = $gun_timer
onready var exhaust = $exhaust

var screen_size = Vector2.ZERO
var vel = Vector2.ZERO
var acc = Vector2.ZERO
var shield_level = globals.shield_max
var shield_up = true

func _ready():
	screen_size = get_viewport_rect().size
	self.position = screen_size / 2
	set_process(true)
	
func _process(delta):
	if shield_up:
		shield_level = min(shield_level + globals.shield_regen, 100)
	if shield_level <= 0 and shield_up:
		shield_up = false
		shield_level = 0
		$shield.hide()
	
	if Input.is_action_pressed("PLAYER_SHOOT"):
		if gun_timer.get_time_left() == 0:
			shoot()
	
	if Input.is_action_pressed("PLAYER_LEFT"):
		rotation -= rot_speed * delta
	if Input.is_action_pressed("PLAYER_RIGHT"):
		rotation += rot_speed * delta	
		
	if Input.is_action_pressed("PLAYER_THRUST"):
		acc = Vector2(thrust, 0).rotated(rotation - PI/2)
		exhaust.show()
	else:
		acc = Vector2.ZERO	
		exhaust.hide()
	acc += vel * -friction #Them friction vao de ship cham dan lai
	
	vel += acc * delta
	position += vel * delta
	if position.x > screen_size.x: #Screen wrapping
		position.x = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y > screen_size.y:
		position.y = 0
	if position.y < 0:
		position.y = screen_size.y
		
func shoot():
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(rotation, nuzzle.get_global_position())
	gun_timer.start()
	shoot_sounds.play()



func _on_player_body_entered(body):
	if body.is_in_group("asteroids"):
		if shield_up:
			body.explode(vel)
			shield_level -= globals.ast_damage[body.size]
		else:
			globals.game_over = true
