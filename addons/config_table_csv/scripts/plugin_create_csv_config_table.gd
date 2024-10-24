@tool
class_name PluginCreateCSVConfigTable extends Node

var editor_file_dialog : EditorFileDialog


func _enter_tree() -> void:
	editor_file_dialog = EditorFileDialog.new()
	self.add_child(editor_file_dialog)
	
	editor_file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	editor_file_dialog.disable_overwrite_warning = true
	editor_file_dialog.title = "Create CSV Config Table"
	editor_file_dialog.filters = PackedStringArray(["*.csv"]) 
	editor_file_dialog.confirmed.connect(create_csv_config_table)
	pass


func show_editor_file_dialog(id: int) -> void:
	if id != PluginConfigHelper.ID_CREATE_CSV_CONFIG_TABLE:
		return
	
	editor_file_dialog.popup_file_dialog()
	pass

func create_csv_config_table() -> void:
	var csv_file_name : String = check_csv_file_name(editor_file_dialog.current_file)
	if csv_file_name.is_empty():
		printerr(PluginConfigHelper.ERR_MESSAGE_START + "File name error")
		return
	
	# create same name dir
	var csv_dir_name : String = get_csv_same_name_dir(csv_file_name)
	
	var csv_dir_path : String = check_csv_dir_path(editor_file_dialog.current_dir)
	if csv_dir_path.is_empty():
		printerr(PluginConfigHelper.ERR_MESSAGE_START + "Dir error")
		return
	
	if FileAccess.file_exists(csv_dir_path + csv_dir_name + csv_file_name):
		printerr(PluginConfigHelper.ERR_MESSAGE_START + "File already exist")
		return
	
	DirAccess.make_dir_absolute(csv_dir_path + csv_dir_name)
	var csv_file_path : String = csv_dir_path + csv_dir_name + csv_file_name
	
	# create csv import config file
	var csv_file_import : FileAccess = FileAccess.open(csv_file_path + ".import", FileAccess.WRITE)
	csv_file_import.store_line("[remap]")
	csv_file_import.store_line("")
	csv_file_import.store_line("importer=\"keep\"")
	csv_file_import.close()
	
	# create csv config table file, write default data
	var csv_file : FileAccess = FileAccess.open(csv_file_path, FileAccess.WRITE)
	# BOM
	csv_file.store_8(0xEF) 
	csv_file.store_8(0xBB)
	csv_file.store_8(0xBF)
	# default data
	csv_file.store_line("unique_id,unique_name")
	csv_file.store_line("int,String")
	csv_file.store_line("唯一id标识,唯一字符串标识")
	csv_file.close()
	
	# refresh
	EditorInterface.get_resource_filesystem().scan()
	pass


func check_csv_file_name(file_name: String) -> String:
	if file_name.is_empty():
		return ""
	
	var suffix_length : int = PluginConfigHelper.CSV_FILE_SUFFIX.length()
	
	if file_name.length() <= suffix_length:
		return file_name + PluginConfigHelper.CSV_FILE_SUFFIX
	
	if file_name.count(PluginConfigHelper.CSV_FILE_SUFFIX, file_name.length() - suffix_length, file_name.length()) <= 0:
		return file_name + PluginConfigHelper.CSV_FILE_SUFFIX
	
	return file_name


func get_csv_same_name_dir(file_name: String) -> String:
	var dir_name : String = file_name.substr(0, file_name.length() - PluginConfigHelper.CSV_FILE_SUFFIX.length())
	return dir_name + "/"


func check_csv_dir_path(dir_path: String) -> String:
	if dir_path.is_empty():
		return ""
	
	if dir_path == PluginConfigHelper.CSV_DIR_PREFIX:
		return dir_path
	
	return dir_path + "/"
