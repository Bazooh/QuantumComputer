class_name Menu extends Control


const editor_scene: PackedScene = preload("res://editor.tscn")


@onready var component_list: BoxContainer = %ComponentList


func edit_component(component_file: String) -> void:
	var computer: Computer = load(component_file).instantiate()

	queue_free()
	var editor: Editor = editor_scene.instantiate()
	get_tree().root.add_child(editor)
	get_tree().current_scene = editor

	editor.computer.queue_free()
	editor.add_child(computer)
	editor.computer = computer


func _ready() -> void:
	for file: String in DirAccess.get_files_at("res://components/"):
		var button := Button.new()
		button.text = file.trim_suffix(".tscn")
		button.pressed.connect(edit_component.bind("res://components/" + file), CONNECT_ONE_SHOT)
		component_list.add_child(button)


func _on_new_button_pressed() -> void:
	get_tree().change_scene_to_packed(editor_scene)