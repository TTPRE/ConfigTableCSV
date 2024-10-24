@tool
extends MarginContainer

@onready var line_edit_csv_config_table_path: LineEdit = $HBoxContainer/LineEditCsvConfigTablePath


var editor_file_dialog : EditorFileDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	editor_file_dialog = EditorFileDialog.new()
	self.add_child(editor_file_dialog)
	
	editor_file_dialog.get_line_edit().editable = false
	editor_file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	editor_file_dialog.title = "Choose CSV Config Table Path"
	editor_file_dialog.disable_overwrite_warning = true
	editor_file_dialog.filters = PackedStringArray(["*.csv"]) 
	editor_file_dialog.confirmed.connect(set_csv_config_table_path)
	pass # Replace with function body.


func _on_button_choose_pressed() -> void:
	editor_file_dialog.popup_file_dialog()
	pass # Replace with function body.


func _on_button_delete_pressed() -> void:
	self.queue_free()
	pass # Replace with function body.


func set_csv_config_table_path() -> void:
	line_edit_csv_config_table_path.text = editor_file_dialog.current_path
	pass
