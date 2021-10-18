extends Node


var chord_bus = AudioServer.get_bus_index("Chord")
var ambience_bus = AudioServer.get_bus_index("ReverbAmbience")

onready var chords = $Music/Chords
onready var tween = $Tween
onready var wood_destroy = $WoodDestroy
onready var ambience = [
	$Ambience1,
	$Ambience2,
	$Ambience3,
	$Ambience4,
	$Ambience5
]


func _ready():
	AudioServer.set_bus_volume_db(chord_bus, -60)
	AudioServer.set_bus_volume_db(ambience_bus, -20)


func ending():
	for child in chords.get_children():
		if child is AudioStreamPlayer:
			tween.interpolate_property(child, "volume_db",
				child.volume_db, -72, 0.1,
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	for node in ambience:
		tween.interpolate_property(node, "volume_db",
			node.volume_db, -72, 0.1,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	wood_destroy.play()


func set_arpeggio_volume(volume: float) -> void:
	for node in chords.arpeggio:
		tween.interpolate_property(node, "volume_db",
			node.volume_db, volume, 0.5,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func set_chord_level(level: int) -> void:
	AudioServer.set_bus_volume_db(chord_bus, min(5, -70.0 + 2 * float(level)))


func set_ambience_level(level: int) -> void:
	AudioServer.set_bus_volume_db(ambience_bus, min(-9.2, -30 + float(level)))
