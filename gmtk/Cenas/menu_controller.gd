extends Control

@export var cena_inicio: PackedScene

func _on_iniciar_button_pressed() -> void:
	get_tree().change_scene_to_packed(cena_inicio)


func _on_sair_button_pressed() -> void:
	get_tree().quit()


func _on_config_button_pressed() -> void:
	pass # Replace with function body.
