extends Button
const lines=[";Sort",
	"[config_stuff]",
	"label_color=\"#000000\" ;text_colour=\"#FFFFFF\"",
	"hash_names=true",
	"background_color0=\"#FFFFFF\"",
	"background_color2=\"\"",
	"reserved_hdd_space_for_animation=1",
	"screen_width=4096 ;not working?",
	"screen_higth=4096 ;may be bugged",
	"disallow_reload_with_F5=true",
	"portrait=true",
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
	file.close()