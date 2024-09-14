class_name List


static func min(array: Array, key = null) -> Variant:
	return array[argmin(array, key)]


static func argmin(array: Array, key = null) -> int:
	var values: Array = array if key == null else array.map(key)

	var min_value: float = values[0]
	var min_idx: int = 0

	for i in range(1, values.size()):
		if values[i] < min_value:
			min_value = values[i]
			min_idx = i
	
	return min_idx
