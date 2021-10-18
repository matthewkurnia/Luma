extends Node


var index = 0

onready var pads = [
	$Pad1,
	$Pad2,
	$Pad3,
	$Pad4
]
onready var choirs = [
	$Choir1,
	$Choir2,
	$Choir3,
	$Choir4
]
onready var arpeggio = [
	$Arpeggio1,
	$Arpeggio2,
	$Arpeggio3,
	$Arpeggio4
]


func _ready():
	pads[index].play()
	choirs[index].play()
	arpeggio[index].play()


func _on_timer_timeout():
	index = (index + 1) % 4
	pads[index].play()
	choirs[index].play()
	arpeggio[index].play()
