@tool
class_name PluginAnalyzeCSVGenerateIdScript


static func generate_id_script(data: Array[PackedStringArray], csv_dir_path: String, csv_file_name_without_suffix: String) -> void:
	if csv_dir_path != PluginConfigHelper.CSV_DIR_PREFIX:
		csv_dir_path += "/"
	
	var id_script_path : String = csv_dir_path + csv_file_name_without_suffix + PluginConfigHelper.ID_SCRIPT_NAME_SUFFIX
	
	var id_script_file : FileAccess = FileAccess.open(id_script_path, FileAccess.WRITE)
	
	id_script_file.store_line(PluginConfigHelper.NEW_FILE_ANNOTATION)
	
	var id_class_name : String = PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.ID_CLASS_NAME_SUFFIX)
	id_script_file.store_line("class_name " + id_class_name)
	id_script_file.store_line("")
	id_script_file.store_line("")
	
	for index : int in range(3, data.size()):
		var new_id_line : String = "const {var_name} : int = {unique_id}"
		new_id_line = new_id_line.format({"var_name":data[index][1].to_upper(), "unique_id":str(data[index][0].to_int())})
		id_script_file.store_line(new_id_line)
	
	id_script_file.close()
	pass
