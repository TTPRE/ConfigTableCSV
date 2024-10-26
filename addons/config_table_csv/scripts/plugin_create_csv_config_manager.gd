@tool
class_name PluginCreateCSVConfigManager extends Node


var instance_scene_plugin_create_csv_config_manager : Window

func _enter_tree() -> void:
	instance_scene_plugin_create_csv_config_manager = load("res://addons/config_table_csv/scenes/plugin_create_csv_config_manager_window/plugin_create_csv_config_manager_window.tscn").instantiate()
	self.add_child(instance_scene_plugin_create_csv_config_manager)
	instance_scene_plugin_create_csv_config_manager.visible = false
	pass


func show_plugin_create_csv_config_helper(id: int) -> void:
	if id != PluginConfigHelper.ID_CREATE_CSV_CONFIG_HELPER:
		return
	
	instance_scene_plugin_create_csv_config_manager.popup_centered()
	pass
