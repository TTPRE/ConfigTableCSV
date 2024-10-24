@tool
class_name PluginCreateCSVConfigHelper extends Node


var instance_scene_plugin_create_csv_config_helper : Window

func _enter_tree() -> void:
	instance_scene_plugin_create_csv_config_helper = load("res://addons/config_table_csv/scenes/plugin_create_csv_config_helper_window/plugin_create_csv_config_helper_window.tscn").instantiate()
	self.add_child(instance_scene_plugin_create_csv_config_helper)
	instance_scene_plugin_create_csv_config_helper.visible = false
	pass


func show_plugin_create_csv_config_helper(id: int) -> void:
	if id != PluginConfigHelper.ID_CREATE_CSV_CONFIG_HELPER:
		return
	
	instance_scene_plugin_create_csv_config_helper.popup_centered()
	pass
