extends Button
const lines=[";Sort",
	"[config_stuff]",
	"cool_color=\"#3F47CC\"",
	"screen_width=4096 ;not working?",
	"George_Carlin=\"The planet is fine. The people are fuckedẞ\"",
	"hash_names=true",
	"background_color0=\"#FFFFFF\"",
	"reserved_hdd_space_for_animation=1",
	"fun_generating_multiplier=0",
	"screen_higth=4096 ;may be bugged",
	"disallow_reload_with_F5=true",
	"portrait=true",
	"ludum_dare_number=45",
	"use_multicores=false",
	"show_title=false",
	"background_color2=\"#FFFFFF\"",
	"foo=23",
	"bar=420",
	"ballmer_peak=\"disabled\"",
	"calculation_delay=1.5",
	"label_colour=\"#FFFFFF\""]

func _on_Initilise_config_button_down():
	var file= File.new()
	if(file.file_exists(Global.config_path)):
		var dir = Directory.new()
		dir.remove(Global.config_path)
	file.open(Global.config_path,File.WRITE)
	for line in lines:
		file.store_line(line)
	file.close()