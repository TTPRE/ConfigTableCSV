##----------------------------------------------------##
##   #######     #######      #######      #######    ##
##  ##     ##  ##       ##  ##       ##  ##       ##  ##
##         ##  ##       ##  ##       ##  ##       ##  ##
##   #######   ##       ##  ##       ##  ##       ##  ##
##  ##         ##       ##  ##       ##  ##       ##  ##
##  ##         ##       ##  ##       ##  ##       ##  ##
##  #########    #######      #######      #######    ##
##----------------------------------------------------##
## @Description: CSV配置表格创建与解析
##
## 1.创建CSV配置表格
## 项目 -> 工具 -> Config Table CSV -> Create CSV Config Table
## 选择文件夹路径，填入CSV配置表格名称（例：item_info或item_info.csv）
## 确定创建。
## 此行为将在选择的文件夹下创建与CSV配置表格同名文件夹，并在同名文件夹下
## 创建CSV配置表格及其导入配置。
## ChooseDir
##   |-item_info
##       |-item_info.csv
##       |-item_info.csv.import
## 
## 2.解析CSV配置表格
## 项目 -> 工具 -> Config Table CSV -> Analyze CSV Config Table
## 选择需要进行解析的CSV配置表格文件，确认解析。
## 此行为将在CSV配置表格文件的同级文件夹下生成四个新文件，如下所示
## ChooseDir
##   |-item
##       |-item_info.csv
##       |-item_info.csv.import
##       |-item_info.gd         （item.csv数据获取gd脚本）
##       |-item_info_analyze.gd （item.csv数据解析gd脚本）
##       |-item_info_data.gd    （item.csv数据类gd脚本）    
##       |-item_info_id.gd      （item.csv唯一id常量gd脚本）
## 
## 3.如何在自己的代码中使用
## 项目 -> 工具 -> Config Table CSV -> Create CSV Config Helper
## 选择csv_config_helper.gd文件路径，并选择任意条csv配置表格路径
## 确认后将生成csv_config_helper.gd文件，并将其以CsvConfigHelper为
## 名称添加到全局自动加载中
## 通过以下四种方式访问数据：
## CsvConfigHelper.item_info.get_csv_data() ## 不建议使用，除非能够确保引用的数据不会被修改，否则请使用函数 get_csv_data_duplicate()
## CsvConfigHelper.item_info.get_csv_data_duplicate() ## 建议使用，相较于 get_csv_data() 更安全，同时会更消耗性能，性能敏感位置评估使用
## CsvConfigHelper.item_info.get_csv_data_line(id: int) ## 不建议使用，除非能够确保引用的数据不会被修改，否则请使用函数 get_csv_data_line_duplicate(id: int)
## CsvConfigHelper.item_info.get_csv_data_line_duplicate(id: int) ## 建议使用，相较于 get_csv_data_line(id: int) 更安全，同时更消耗性能，性能敏感位置评估使用
##
## 
## *注:
##   ①.创建CSV配置表格时写入了BOM头，使用出错时请考虑该原因
##   ②.请按如下方式组织您的配置表格，以防不能够顺利解析配置表格
##      第一行：变量名称
##      第二行：变量注释
##      第三行：变量类型
##      之后的行：数据行
##      前*两列*为默认列务必不要更改并且保证它们数据行中的值的唯一性
##      注释列：第一行变量名称为"###"的列为注释列，注释列将会在解析时跳过
##     +-----------+-------------+-----+-------+--------+---------+-------------+-----------------+
##     | unique_id | unique_name | ### | score | is_old | pos_2d  |   pos_3d    |     message     |
##     +-----------+-------------+-----+-------+--------+---------+------------ +-----------------+
##     | 唯一id标识 | 唯一字符串标识 |     | 分数  |是否是旧的| 2d位置   |   3d位置    |       消息       |
##     +-----------+-------------+-----+-------+--------+---------+-------------+-----------------+
##     |    int    |   string    |     | float |  bool  | vector2 |   vector3   |      array      |
##     +-----------+-------------+-----+-------+--------+---------+-------------+-----------------+
##     |   10001   |   player_1  |玩家1 | 132.6 |  TRUE  | 1.0,2.5 | 1.0,1.0,1.0 | 11;22;it's true |
##     +-----------+-------------+-----+-------+--------+---------+-------------+-----------------+
##   ③.已支持的数据类型:括号中代表可以在CSV表格中填入的类型样式，冒号后给出两个数据行示例
##      int(int, Int, INT): \1\ \10001\
##      float(float, Float, FLOAT): \1.5\ \132.6\
##      String(string, String, STRING): \s_name\ \player_1\
##      bool(bool, Bool, BOOL): \TRUE\ \1\ \0\ \true\ \True\ \false\
##      Vector2(vector2, Vector2, VECTOR2): \1.0,2.5\ \100,3.3\
##      Vector3(vector3, Vector3, VECTOR3): \1.0,1.0,1.0\ \1.1,2.2,3.3\
##      Array(array, Array, ARRAY): \11;22;it's true\  \abc;def;ghi;jkl\
##----------------------------------------------------##
## @Auther: 2000
## @Date: 2024-10-18
## @LastEditTime: 2024-10-25
## @Tags: CSV, 配置, 解析
## @Version: 1.0.0
## @License: MIT license
## @ContactInformation:
##----------------------------------------------------##
@tool
extends EditorPlugin


var plugin_create_csv_config_table : PluginCreateCSVConfigTable
var plugin_analyze_csv_config_table : PluginAnalyzeCSVConfigTable
var plugin_create_csv_config_helper : PluginCreateCSVConfigHelper

func _enter_tree() -> void:
	initialize()
	add_config_table_csv_menu()
	print("Enable ConfigTableCSV")
	pass


func _exit_tree() -> void:
	remove_config_table_csv_menu()
	destroy()
	print("Disable ConfigTableCSV")
	pass


func initialize() -> void:
	plugin_create_csv_config_table = PluginCreateCSVConfigTable.new()
	self.add_child(plugin_create_csv_config_table)
	
	plugin_analyze_csv_config_table = PluginAnalyzeCSVConfigTable.new()
	self.add_child(plugin_analyze_csv_config_table)
	
	plugin_create_csv_config_helper = PluginCreateCSVConfigHelper.new()
	self.add_child(plugin_create_csv_config_helper)
	pass


func destroy() -> void:
	plugin_create_csv_config_table.free()
	plugin_analyze_csv_config_table.free()
	plugin_create_csv_config_helper.free()
	pass


func add_config_table_csv_menu() -> void:
	var popup_menu_config_table_csv : PopupMenu = PopupMenu.new()
	
	popup_menu_config_table_csv.add_item("Create CSV Config Table", PluginConfigHelper.ID_CREATE_CSV_CONFIG_TABLE)
	popup_menu_config_table_csv.id_pressed.connect(plugin_create_csv_config_table.show_editor_file_dialog)
	
	popup_menu_config_table_csv.add_item("Analyze CSV Config Table", PluginConfigHelper.ID_ANALYZE_CSV_CONFIG_TABLE)
	popup_menu_config_table_csv.id_pressed.connect(plugin_analyze_csv_config_table.show_editor_file_dialog)
	
	popup_menu_config_table_csv.add_item("Create CSV Config Helper", PluginConfigHelper.ID_CREATE_CSV_CONFIG_HELPER)
	popup_menu_config_table_csv.id_pressed.connect(plugin_create_csv_config_helper.show_plugin_create_csv_config_helper)
	
	add_tool_submenu_item("Config Table CSV", popup_menu_config_table_csv)
	pass


func remove_config_table_csv_menu() -> void:
	remove_tool_menu_item("Config Table CSV")
	pass
