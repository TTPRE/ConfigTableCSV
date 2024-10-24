@tool
class_name PluginAnalyzeCSVConfigTable extends Node

var editor_file_dialog : EditorFileDialog


func _enter_tree() -> void:
	editor_file_dialog = EditorFileDialog.new()
	self.add_child(editor_file_dialog)
	
	editor_file_dialog.get_line_edit().editable = false
	editor_file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	editor_file_dialog.title = "Analyze CSV Config Table"
	editor_file_dialog.filters = PackedStringArray(["*.csv"]) 
	editor_file_dialog.confirmed.connect(analyze_csv_config_table)
	pass


func show_editor_file_dialog(id: int) -> void:
	if id != PluginConfigHelper.ID_ANALYZE_CSV_CONFIG_TABLE:
		return
	
	editor_file_dialog.popup_file_dialog()
	pass


func analyze_csv_config_table() -> void:
	var csv_file_path : String = editor_file_dialog.current_path
	var csv_file : FileAccess = FileAccess.open(csv_file_path, FileAccess.READ)
	
	var csv_config_table_data : Array[PackedStringArray]
	while csv_file.get_position() < csv_file.get_length():
		var data : PackedStringArray = csv_file.get_csv_line()
		csv_config_table_data.push_back(data)
	csv_file.close()
	
	var csv_file_name_without_suffix : String = remove_csv_file_name_suffix(editor_file_dialog.current_file)
	
	PluginAnalyzeCSVGenerateDataScript.generate_data_script(csv_config_table_data, editor_file_dialog.current_dir, csv_file_name_without_suffix)
	PluginAnalyzeCSVGenerateIdScript.generate_id_script(csv_config_table_data, editor_file_dialog.current_dir, csv_file_name_without_suffix)
	PluginAnalyzeCSVGenerateAnalyzeScript.generate_analyze_script(csv_config_table_data, editor_file_dialog.current_dir, csv_file_name_without_suffix)
	PluginAnalyzeCSVGenerateScript.generate_script(csv_config_table_data, editor_file_dialog.current_dir, csv_file_name_without_suffix)
	
	# refresh
	EditorInterface.get_resource_filesystem().scan()
	pass


func remove_csv_file_name_suffix(csv_file_name: String) -> String:
	return csv_file_name.substr(0, csv_file_name.length() - PluginConfigHelper.CSV_FILE_SUFFIX.length())
	
