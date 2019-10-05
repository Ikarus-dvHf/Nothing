extends Node
#
enum FileNames {Main, config, SetUp, Game, Player, Boss}

var path="res://files/"
var main_path=path+"Main.txt"
var config_path=path+"Config.cfg"
var boss_path=path+"Boss.cfg"
var player_path=path+"Player.cfg"
var time_path="res://data"
var config 

var background_colors
var text_color

var player_name
var player_image
var boss_name
var boss_image

var start_time

func _ready():
	load_config()
	
func load_config():
	config= ConfigFile.new()
	var err=config.load(config_path)
	if err!=OK:
		return
	get_time()
	background_colors=[]
	background_colors.resize(3)
	background_colors[0]=Color(config.get_value("config_stuff","background_color0", "#FFFFFF"))
	background_colors[1]=Color(config.get_value("config_stuff","background_color1", "#FFFFFF"))
	background_colors[2]=Color(config.get_value("config_stuff","background_color2", "#FFFFFF"))
	var tmp=config.get_value("config_stuff","label_color")
	print (tmp)
	if(null!=tmp):
		text_color=Color(tmp)
	else:
		text_color=background_colors[0]
	if(config.get_value("config_stuff","portrait",true)):
		OS.set_window_size(Vector2(600,800))
	else:
		OS.set_window_size(Vector2(800,600))

func set_colors(control):
	var theme =control.get_theme()
	theme.set_color("font_color","Label",text_color)
	theme.set_color("font_color","ProgressBar",text_color)
		
func read_main():
	var file = File.new()
	if(!file.file_exists(main_path)):
		return false;
	file.open(main_path,File.READ)
	var start=true
	while not file.eof_reached():
		var line = file.get_line()
		if(line.begins_with(";")):
			continue
		start =start && line.find("nothing")==-1
	file.close()
	return start
	
func get_time():
	var f=File.new()	
	if(f.file_exists(time_path)):
		f. open_encrypted_with_pass(time_path,File.READ,"SUA==jsASasdb7sfOI=8213")
		start_time=f.get_64()
	else:
		f.open_encrypted_with_pass(time_path,File.WRITE,"SUA==jsASasdb7sfOI=8213")
		start_time=OS.get_unix_time()
		f.store_64(start_time)
	f.close()