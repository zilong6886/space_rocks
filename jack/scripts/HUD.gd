extends CanvasLayer

func update(player):
	update_shield(player.shield_level)
	$score.set_text(str(globals.score))

func update_shield(shield_level):
	var color = "green"
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	var texture = load("res://assets/art/gui/barHorizontal_%s_mid 200.png" % color)
	$shield_bar.texture_progress = texture
	$shield_bar.value = shield_level
