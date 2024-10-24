@tool
class_name PluginAnalyzeCSVGenerateAnalyzeScript


static func generate_analyze_script(data: Array[PackedStringArray], csv_dir_path: String, csv_file_name_without_suffix: String) -> void:
	if csv_dir_path != PluginConfigHelper.CSV_DIR_PREFIX:
		csv_dir_path += "/"
	
	var analyze_script_path : String = csv_dir_path + csv_file_name_without_suffix + PluginConfigHelper.ANALYZE_SCRIPT_NAME_SUFFIX
	
	var psa_variable_name : PackedStringArray = data[0]
	var psa_variable_type : PackedStringArray = data[1]
	var psa_variable_annotation : PackedStringArray = data[2]
	
	var analyze_script_file : FileAccess = FileAccess.open(analyze_script_path, FileAccess.WRITE)
	
	analyze_script_file.store_line(PluginConfigHelper.NEW_FILE_ANNOTATION)
	
	var analyze_class_name : String = PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.ANALYZE_CLASS_NAME_SUFFIX)
	analyze_script_file.store_line("class_name " + analyze_class_name)
	analyze_script_file.store_line("")
	
	var csv_table_path : String = csv_dir_path + csv_file_name_without_suffix + PluginConfigHelper.CSV_FILE_SUFFIX
	analyze_script_file.store_line(PluginConfigHelper.CONST_CSV_TABLE_PATH.format({"csv_table_path":csv_table_path}))
	analyze_script_file.store_line("")
	
	analyze_script_file.store_line(PluginConfigHelper.FUNCTION_LOAD_CSV_CONFIG_TABLE)
	analyze_script_file.store_line("")
	
	var data_class_name : String = PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.DATA_CLASS_NAME_SUFFIX)
	analyze_script_file.store_line(PluginConfigHelper.FUNCTION_GET_CONFIG_DATA_BEGIN.format({"class_name":data_class_name}))
	
	for index : int in range(psa_variable_name.size()):
		var new_analyze_line : String
		var type : String = PluginConfigHelper.get_type_standard_format(psa_variable_type[index])
		match type:
			"int":
				new_analyze_line = analyze_type_int(psa_variable_name[index], index)
			"float":
				new_analyze_line = analyze_type_float(psa_variable_name[index], index)
			"String":
				new_analyze_line = analyze_type_string(psa_variable_name[index], index)
			"bool":
				new_analyze_line = analyze_type_bool(psa_variable_name[index], index)
			"Vector2":
				new_analyze_line = analyze_type_vector2(psa_variable_name[index], index)
			"Vector3":
				new_analyze_line = analyze_type_vector3(psa_variable_name[index], index)
			"Array":
				new_analyze_line = analyze_type_array(psa_variable_name[index], index)
		
		analyze_script_file.store_line(new_analyze_line)
	
	analyze_script_file.store_line(PluginConfigHelper.FUNCTION_GET_CONFIG_DATA_END)
	analyze_script_file.store_line("")
	
	analyze_script_file.store_line(PluginConfigHelper.FUNCTION_GET_SPECIFY_TYPE_DATA_FROM_STRING)
	
	analyze_script_file.close()
	pass


static func analyze_type_int(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = csv_table_data_line[{index}].to_int()"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_float(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = csv_table_data_line[{index}].to_float()"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_string(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = csv_table_data_line[{index}]"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_bool(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = get_bool_from_string(csv_table_data_line[{index}])"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_vector2(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = get_vector2_from_string(csv_table_data_line[{index}])"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_vector3(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = get_vector3_from_string(csv_table_data_line[{index}])"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line


static func analyze_type_array(variable_name: String, index: int) -> String:
	var new_analyze_line : String = "\t\tnew_data.{variable_name} = get_array_from_string(csv_table_data_line[{index}])"
	new_analyze_line = new_analyze_line.format({"variable_name":variable_name, "index":str(index)})
	return new_analyze_line
