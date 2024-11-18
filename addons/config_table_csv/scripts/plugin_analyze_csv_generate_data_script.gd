@tool
class_name PluginAnalyzeCSVGenerateDataScript


static func generate_data_script(data: Array[PackedStringArray], csv_dir_path: String, csv_file_name_without_suffix: String) -> void:
	if csv_dir_path != PluginCTSConfigHelper.CSV_DIR_PREFIX:
		csv_dir_path += "/"
	
	var data_script_path : String = csv_dir_path + csv_file_name_without_suffix + PluginCTSConfigHelper.DATA_SCRIPT_NAME_SUFFIX
	
	var psa_variable_name : PackedStringArray = data[0]
	var psa_variable_type : PackedStringArray = data[1]
	var psa_variable_annotation : PackedStringArray = data[2]
	
	var data_script_file : FileAccess = FileAccess.open(data_script_path, FileAccess.WRITE)
	
	data_script_file.store_line(PluginCTSConfigHelper.NEW_FILE_ANNOTATION)
	
	var data_class_name : String = PluginCTSConfigHelper.get_class_name(csv_file_name_without_suffix, PluginCTSConfigHelper.DATA_CLASS_NAME_SUFFIX)
	data_script_file.store_line("class_name " + data_class_name)
	data_script_file.store_line("")
	data_script_file.store_line("")

	for index : int in range(psa_variable_name.size()):
		if psa_variable_name[index] == PluginCTSConfigHelper.CSV_CONFIG_TABLE_ANNOTATION_COLUMN_VARIABLE_NAME:
			continue
		var new_data_line : String
		var type : String = PluginCTSConfigHelper.get_type_standard_format(psa_variable_type[index])
		if type == "Array":
			new_data_line = "var {var_name} : Array[String] ##{annotation}".format({"var_name":psa_variable_name[index], "annotation":psa_variable_annotation[index]})
		else:
			new_data_line = "var {var_name} : {var_type} ##{annotation}".format({"var_name":psa_variable_name[index], "var_type":type, "annotation":psa_variable_annotation[index]})
		data_script_file.store_line(new_data_line)
	data_script_file.store_line("")
	data_script_file.store_line("")
	
	data_script_file.store_line("func duplicate() -> {class_name}:".format({"class_name": data_class_name}))
	data_script_file.store_line("\tvar data : {class_name} = {class_name}.new()".format({"class_name": data_class_name}))
	for index : int in range(psa_variable_name.size()):
		if psa_variable_name[index] == PluginCTSConfigHelper.CSV_CONFIG_TABLE_ANNOTATION_COLUMN_VARIABLE_NAME:
			continue
		var new_data_line : String
		var type : String = PluginCTSConfigHelper.get_type_standard_format(psa_variable_type[index])
		if type == "Array":
			new_data_line = "\tdata.{var_name} = {var_name}.duplicate(true)".format({"var_name":psa_variable_name[index]})
		else:
			new_data_line = "\tdata.{var_name} = {var_name}".format({"var_name":psa_variable_name[index]})
		data_script_file.store_line(new_data_line)
	data_script_file.store_line("\treturn data")
	
	data_script_file.close()
	pass
