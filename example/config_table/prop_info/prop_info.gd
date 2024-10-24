## This file is generated by the ConfigTableCSV plugin
class_name PropInfo



var _a_prop_info : Array[PropInfoData] ##不要直接使用该变量，请使用函数访问
var _d_prop_info : Dictionary ##不要直接使用该变量，请使用函数访问


## 初始化
func _init() -> void:
	_a_prop_info = PropInfoAnalyze.get_config_data()
	for data : PropInfoData in _a_prop_info:
		_d_prop_info[data.unique_id] = data
	pass


## 不建议使用，除非能够确保引用的数据不会被修改，否则请使用函数 get_csv_data_duplicate()
func get_csv_data() -> Array[PropInfoData]:
	return _a_prop_info


## 建议使用，相较于 get_csv_data() 更安全，同时会更消耗性能，性能敏感位置评估使用
func get_csv_data_duplicate() -> Array[PropInfoData]:
	return _a_prop_info.duplicate(true)


## 不建议使用，除非能够确保引用的数据不会被修改，否则请使用函数 get_csv_data_line_duplicate(id: int)
func get_csv_data_line(id: int) -> PropInfoData:
	if not _d_prop_info.has(id):
		return null
	return _d_prop_info[id]


## 建议使用，相较于 get_csv_data_line(id: int) 更安全，同时更消耗性能，性能敏感位置评估使用
func get_csv_data_line_duplicate(id: int) -> PropInfoData:
	if not _d_prop_info.has(id):
		return null
	return _d_prop_info[id].duplicate()
