class_name Set


var values: Dictionary

func _init() -> void:
	values = {}


func add(value: Variant) -> void:
	values[value] = true


func erase(value: Variant) -> bool:
	return values.erase(value)


static func from(array: Array) -> Set:
	var new_set := Set.new()
	for value in array:
		new_set.add(value)
	return new_set