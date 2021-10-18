extends Area2D


export var volume = -80.0


func _on_MusicTrigger_body_entered(body):
	if body.is_in_group("player"):
		print("A")
		Sound.set_arpeggio_volume(volume)
