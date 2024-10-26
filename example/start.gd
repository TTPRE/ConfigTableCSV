extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var prop_info : Array[PropInfoData] = CsvConfigManager.prop_info.get_csv_data_duplicate()
	for prop_info_data : PropInfoData in prop_info:
		print(prop_info_data.unique_id, " ",
				prop_info_data.unique_name, " ",
				prop_info_data.damage, " ",
				prop_info_data.is_melee_weapon, " ",
				prop_info_data.pos_2d, " ",
				prop_info_data.pos_3d, " ",
				prop_info_data.tags)
	
	print()
	
	var gun_info_data : PropInfoData = CsvConfigManager.prop_info.get_csv_data_line_duplicate(PropInfoID.GUN)
	print(gun_info_data.unique_id, " ",
			gun_info_data.unique_name, " ",
			gun_info_data.damage, " ",
			gun_info_data.is_melee_weapon, " ",
			gun_info_data.pos_2d, " ",
			gun_info_data.pos_3d, " ",
			gun_info_data.tags)
	pass # Replace with function body.
