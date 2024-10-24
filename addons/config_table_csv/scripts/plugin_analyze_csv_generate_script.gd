@tool
class_name PluginAnalyzeCSVGenerateScript


static func generate_script(data: Array[PackedStringArray], csv_dir_path: String, csv_file_name_without_suffix: String) -> void:
	if csv_dir_path != PluginConfigHelper.CSV_DIR_PREFIX:
		csv_dir_path += "/"
	
	var script_path : String = csv_dir_path + csv_file_name_without_suffix + PluginConfigHelper.SCRIPT_NAME_SUFFIX
	
	var script_file : FileAccess = FileAccess.open(script_path, FileAccess.WRITE)
	
	script_file.store_line(PluginConfigHelper.NEW_FILE_ANNOTATION)
	
	var new_class_name : String = PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.CLASS_NAME_SUFFIX)
	script_file.store_line("class_name " + new_class_name)
	script_file.store_line("")
	script_file.store_line("")
	
	script_file.store_line(PluginConfigHelper.SCRIPT_FILE_DATA.format({
			"csv_file_name":csv_file_name_without_suffix,
			"data_class_name":PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.DATA_CLASS_NAME_SUFFIX),
			"analyze_class_name":PluginConfigHelper.get_class_name(csv_file_name_without_suffix, PluginConfigHelper.ANALYZE_CLASS_NAME_SUFFIX)}))
	
	script_file.close()
	pass
