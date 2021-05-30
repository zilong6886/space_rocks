extends CanvasLayer

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("PAUSE_TOGGLE"):
		globals.paused = not globals.paused
		get_tree().set_pause(globals.paused)
		$pause_popup.visible = globals.paused
		$message.visible = not globals.paused
		if $message.visible:
			$message_timer.start()

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

func show_message(text):
	$message.text = text
	$message.show()
	$message_timer.start()

func _on_message_timer_timeout():
	$message.hide()
