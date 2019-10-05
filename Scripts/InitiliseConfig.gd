extends Button
const lines=[";Sort into right Categories",
	"[config_stuff]",
	"text_color=\"#000000\" ;text_colour=\"#FFFFFF\"",
	"hash_names=true",
	"background_color=\"#FFFFFF\"",
	"border_color1=\"\"",
	"border_color3=\"#FFFFFF\"",
	"reserved_hdd_space_for_animation=1",
	"screen_width=1",
	"screen_higth=1",
	"disallow_reload_wifh_F5=true",
	"portrait=false",
	"show_title=false"]

func _on_Initilise_config_button_down():
	var file= File.new()
	if(file.file_exists(Global.config_path)):
		var dir = Directory.new()
		dir.remove(Global.config_path)
	file.open(Global.config_path,File.WRITE)
	for line in lines:
		file.store_line(line)
	get_parent().show_settings()