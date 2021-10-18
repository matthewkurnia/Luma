extends CanvasLayer


var paused := false
var can_pause := false

onready var menu = $Control


func _ready():
	menu.visible = false


func _input(event):
	if not can_pause:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		paused = not paused
		menu.visible = paused
		get_tree().paused = paused


func _on_Continue_pressed():
	paused = not paused
	menu.visible = paused
	get_tree().paused = paused


func _on_Quit_pressed():
	get_tree().quit()
