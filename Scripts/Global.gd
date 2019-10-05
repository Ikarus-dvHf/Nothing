extends Node
#
enum FileNames {Main, config, SetUp, Game, Player, Boss}

var path="res://files/"
var main_path=path+"Main.txt"
var config_path=path+"Config.cfg"
var boss_path=path+"Boss.cfg"
var config 

var background_color
var text_color
var border_colors

var player_name
var player_image
var boss_name
var boss_image




	
func _ready():
	if (loadConfig()):
		background_color=Color(config.get_value("config_stuff","background_color", "#FFC0CB"))
		var tmp=Color(config.get_value("config_stuff","text_color"))
		if(null!=tmp):
			text_color=tmp
		else:
			text_color=background_color
		border_colors=[]
		border_colors.resize(3)
		border_colors[0]=Color(config.get_value("config_stuff","border_color1", "#FFFFFF"))
		border_colors[1]=Color(config.get_value("config_stuff","border_color2", "#FFFFFF"))
		border_colors[2]=Color(config.get_value("config_stuff","border_color3", "#FFFFFF"))
		resize()

func resize():
	if(config.get_value("config_stuff","portrait",true)):
		OS.set_window_size(Vector2(600,800))
	else:
		OS.set_window_size(Vector2(800,600))
			
func readFromFile(name):
	var file = ConfigFile.new()
	file.load(name)
	
func loadConfig():
	config= ConfigFile.new()
	var err=config.load(config_path)
	return err==OK
		
	
func readMain():
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