extends Control

@export var cena: PackedScene

func _ready() -> void:
	MinigameManagerScene.pausar_timer(true)


func _on_tree_exited() -> void:
	MinigameManagerScene.pausar_timer(false)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(cena)
