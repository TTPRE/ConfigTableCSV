@tool
extends Window

@onready var line_edit_csv_config_helper_path: LineEdit = $Panel/VBoxContainer/VBoxContainerCsvConfigHelper/HBoxContainer/MarginContainer/LineEditCsvConfigHelperPath

@onready var scene_plugin_choose_csv_config_table_path : PackedScene = load("res://addons/config_table_csv/scenes/plugin_choose_csv_config_table_path/plugin_choose_csv_config_table_path.tscn")
@onready var v_box_container_cvs_table_path: VBoxContainer = $Panel/VBoxContainer/VBoxContainerCsvTableFile/MarginContainer/Panel/MarginContainer4/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainerCvsTablePath

var editor_file_dialog : EditorFileDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	editor_file_dialog = EditorFileDialog.new()
	self.add_child(editor_file_dialog)
	
	editor_file_dialog.get_line_edit().editable = false
	editor_file_dialog.get_line_edit().text = PluginConfigHelper.CSV_CONFIG_HELPER_SCRIPT_NAME
	editor_file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	editor_file_dialog.title = "Set CsvConfigHelper Path"
	editor_file_dialog.disable_overwrite_warning = true
	editor_file_dialog.filters = PackedStringArray(["*.gd"]) 
	editor_file_dialog.confirmed.connect(set_csv_config_helper_path)
	pass # Replace with function body.


func set_csv_config_helper_path() -> void:
	editor_file_dialog.get_line_edit().text = PluginConfigHelper.CSV_CONFIG_HELPER_SCRIPT_NAME
	line_edit_csv_config_helper_path.text = editor_file_dialog.current_path
	pass


func _on_button_ok_pressed() -> void:
	var csv_config_helper_path : String = line_edit_csv_config_helper_path.text
	var a_csv_config_table_path : Array[String]
	
	var choose_csv_config_table_path_nodes: Array[Node] = v_box_container_cvs_table_path.get_children()
	for node in choose_csv_config_table_path_nodes:
		var csv_config_table_path : String = node.line_edit_csv_config_table_path.text
		if csv_config_table_path.is_empty():
			continue
		a_csv_config_table_path.append(csv_config_table_path)
		
	create_csv_config_helper_autoload_script(csv_config_helper_path, a_csv_config_table_path)
	pass # Replace with function body.


func _on_button_cancle_pressed() -> void:
	self.visible = false
	pass # Replace with function body.


func _on_button_set_csv_config_helper_path_pressed() -> void:
	editor_file_dialog.popup_file_dialog()
	editor_file_dialog.get_line_edit().text = PluginConfigHelper.CSV_CONFIG_HELPER_SCRIPT_NAME
	pass # Replace with function body.


func _on_button_add_pressed() -> void:
	var instance_scene_plugin_choose_csv_config_table_path : Control = scene_plugin_choose_csv_config_table_path.instantiate()
	v_box_container_cvs_table_path.add_child(instance_scene_plugin_choose_csv_config_table_path)
	pass # Replace with function body.


func create_csv_config_helper_autoload_script(csv_config_helper_path: String,a_csv_config_table_path: Array[String]) -> void:
	var a_csv_config_helper_data_line : Array[String]
	# 判断路径是否存在自动加载脚本 存在则读取内容
	if FileAccess.file_exists(csv_config_helper_path):
		var file : FileAccess = FileAccess.open(csv_config_helper_path, FileAccess.READ)
		while file.get_position() < file.get_length():
			var data : String = file.get_line()
			a_csv_config_helper_data_line.push_back(data)
		file.close()
	
	# 写文件
	var file : FileAccess = FileAccess.open(csv_config_helper_path, FileAccess.WRITE)
	for data_line : String in a_csv_config_helper_data_line:
		file.store_line(data_line)
	
	if a_csv_config_helper_data_line.is_empty():
		file.store_line(PluginConfigHelper.NEW_FILE_ANNOTATION)
		file.store_line("extends Node")
		file.store_line("")
		file.store_line("")
	
	
	for path in a_csv_config_table_path:
		if not FileAccess.file_exists(path):
			continue
		
		var file_name_without_suffix : String = get_file_name_without_suffix_from_path(path)
		var csv_get_class_name : String = PluginConfigHelper.get_class_name(file_name_without_suffix, PluginConfigHelper.CLASS_NAME_SUFFIX)
		var new_data_line = "var {var_name} : {class_name} = {class_name}.new()".format({"var_name":file_name_without_suffix, "class_name":csv_get_class_name})
		if a_csv_config_helper_data_line.has(new_data_line):
			continue
		
		a_csv_config_helper_data_line.append(new_data_line)
		file.store_line(new_data_line)
	
	file.close()
	
	# refresh
	EditorInterface.get_resource_filesystem().scan()
	
	var editor_plugin : EditorPlugin = EditorPlugin.new()
	editor_plugin.add_autoload_singleton(PluginConfigHelper.CSV_CONFIG_HELPER_AUTOLOAD_NAME, csv_config_helper_path)
	
	self.visible = false
	pass


func get_file_name_without_suffix_from_path(csv_config_table_path: String) -> String:
	var file_name_without_suffix : String
	if csv_config_table_path.is_empty():
		return file_name_without_suffix
	file_name_without_suffix = csv_config_table_path.replace(PluginConfigHelper.CSV_FILE_SUFFIX, "")
	var index : int = file_name_without_suffix.rfind("/")
	file_name_without_suffix = file_name_without_suffix.substr(index + 1)
	return file_name_without_suffix
