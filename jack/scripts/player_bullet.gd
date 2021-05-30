extends Area2D

var vel = Vector2.ZERO
export var speed = 1000

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	position += vel * delta
	
func start_at(dir, pos):
	rotation = dir
	position = pos
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	$lifetime.start()


func _on_lifetime_timeout():
	queue_free()


func _on_player_bullet_body_entered(body):
	if body.is_in_group("asteroids"):
		queue_free()
		body.explode(vel.normalized())
