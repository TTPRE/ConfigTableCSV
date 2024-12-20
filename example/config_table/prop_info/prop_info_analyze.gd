## This file is generated by the ConfigTableCSV plugin
class_name PropInfoAnalyze


## csv配置表格文件路径
const CSV_TABLE_PATH : String = "res://example/config_table/prop_info/prop_info.csv"
## 数据行开始行
const CSV_TABEL_DATA_LINE_BEGIN : int = 3

## 加载cvs表格数据以数组形式返回
static func load_csv_config_table(csv_table_path: String) -> Array[PackedStringArray]:
	var csv_table_data : Array[PackedStringArray] = []
	var file : FileAccess = FileAccess.open(csv_table_path, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data : PackedStringArray = file.get_csv_line()
		csv_table_data.push_back(data)
	file.close()
	return csv_table_data


## 获取数据并转化变量类型
static func get_config_data() -> Array[PropInfoData]:
	var result : Array[PropInfoData] = []
	var csv_table_data : Array[PackedStringArray] = load_csv_config_table(CSV_TABLE_PATH)
	
	for index : int in range(CSV_TABEL_DATA_LINE_BEGIN, csv_table_data.size()):
		var csv_table_data_line : PackedStringArray = csv_table_data[index]
		
		var new_data : PropInfoData = PropInfoData.new()
		new_data.unique_id = csv_table_data_line[0].to_int()
		new_data.unique_name = csv_table_data_line[1]
		new_data.damage = csv_table_data_line[3].to_float()
		new_data.is_melee_weapon = get_bool_from_string(csv_table_data_line[4])
		new_data.pos_2d = get_vector2_from_string(csv_table_data_line[5])
		new_data.pos_3d = get_vector3_from_string(csv_table_data_line[6])
		new_data.tags = get_array_from_string(csv_table_data_line[7])
		
		result.push_back(new_data)
	return result


static func remove_str_space(data: String) -> String:
	return data.replace(" ","")


static func get_bool_from_string(data: String) -> bool:
	data = remove_str_space(data)
	if data == "true" or data == "True" or data == "TRUE" or data == "1":
		return true
	return false


static func get_vector2_from_string(data: String) -> Vector2:
	data = remove_str_space(data)
	data = data.replace("，", ",")
	var psa_data : PackedStringArray = data.split(",", false, 1)
	if psa_data.size() < 2:
		return Vector2.ZERO
	var resault : Vector2 = Vector2(psa_data[0].to_float(), psa_data[1].to_float())
	return resault


static func get_vector3_from_string(data: String) -> Vector3:
	data = remove_str_space(data)
	data = data.replace("，", ",")
	var psa_data : PackedStringArray = data.split(",", false, 2)
	if psa_data.size() < 3:
		return Vector3.ZERO
	var resault : Vector3 = Vector3(psa_data[0].to_float(), psa_data[1].to_float(), psa_data[2].to_float())
	return resault


static func get_array_from_string(data: String) -> Array[String]:
	data = data.replace("；", ";")
	var psa_data : PackedStringArray = data.split(";", false)
	var resault : Array[String] = []
	for temp : String in psa_data:
		resault.append(temp)
	return resault
