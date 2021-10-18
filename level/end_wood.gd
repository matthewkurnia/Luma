extends StaticBody2D


var player


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	if player.attacking:
		end_game()


func end_game():
	Sound.ending()
	get_tree().change_scene("res://level/end_screen.tscn")


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_physics_process(true)


func _on_area_body_exited(body):
	if body.is_in_group("player"):
		set_physics_process(false)
