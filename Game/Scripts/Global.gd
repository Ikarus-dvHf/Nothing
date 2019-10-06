extends Node
#
enum FileNames {Main, config, SetUp, Game, Player, Boss}

onready var path="./"
onready var main_path=path+"README.txt"
onready var config_path=path+"Config.cfg"
onready var boss_path=path+"Boss.cfg"
onready var player_path=path+"Player.cfg"
onready var time_path="data"
var config 

var background_colors
var text_color

var player_name
var player_image
var boss_name
var boss_image
var rolling=false

var start_time
	
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
	if(config.has_section_key("config_stuff","label_color")):
		text_color=Color(config.get_value("config_stuff","label_color", "#FFFFFF"))
	elif(background_colors==null):
		text_color=Color.white
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
		
func readme():
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