class_name GateButton extends Button


@export var gate: Script


func _on_pressed() -> void:
	var gate_instance := Gate.gate_scene.instantiate()
	get_tree().root.add_child(gate_instance)
	gate_instance.ghost = true
	gate_instance.move_to(get_viewport().get_mouse_position())