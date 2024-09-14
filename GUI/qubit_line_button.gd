class_name QubitLineButton extends Button


const qubit_line_scene: PackedScene = preload("res://nodes/qubit_line.tscn")


@onready var editor: Editor = owner


func _on_pressed() -> void:
	if not editor.can_edit():
		return

	var instance: QubitLine = qubit_line_scene.instantiate()
	editor.computer.qubit_lines.add_child(instance)
	instance.init_ghost(editor, get_viewport().get_mouse_position())
	editor.placing_placable = true
	editor.placable = instance