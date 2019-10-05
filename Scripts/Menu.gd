extends VBoxContainer

onready var file_dialog_player= $FileDialogPlayer
onready var file_dialog_boss= $FileDialogBoss

func _ready():
	if(Global.readMain()):
		$InitiliseConfig.visible=true
		var file = File.new()
		if file.file_exists(Global.config_path):
			show_settings()
	$Title.visible= Global.config.get_value("config_stuff","show_title", false)
			
func _input(event):
	if event.is_action_pressed("RELOAD")&& !Global.config.get_value("config_stuff","disallow_reload_with_F5",true):
		Global.resize()
		get_tree().reload_current_scene()
		
func show_settings():
	$Control.visible=true

func _on_Start_button_down():
	var tmp =get_node("./Control/Player/PlayerName").get_text()
	var tmp2= get_node("./Control/Boss/BossName").get_text()
	if(get_node("./Control/Start/ConfirmCode").get_text()=="done" && tmp!="" && tmp2!="" ):
		Global.player_name= tmp
		Global.boss_name= tmp2
		var file = File.new()
		if !file.file_exists(Global.boss_path):
			$FileNotFound.popup()
		else:
			get_tree().change_scene("res://Scenes/Game.tscn")


func _on_FileDialogPlayer_file_selected(path):
	Global.player_image=Image.new()
	Global.player_image = load(path)
	if Global.player_image.get_width()!=256 ||  Global.player_image.get_height!=256:
		Global.player_image =null
		printerr("Wrong Image size")
		
		
func _on_FileDialogBoss_file_selected(path):
	Global.boss_image=Image.new()
	Global.boss_image = load(path)
	if Global.boss_image.get_width()!=256 ||  Global.boss_image.get_height!=256:
		Global.boss_image =null
		printerr("Wrong Image size")

func _on_PlayerImage_button_down():
	file_dialog_player.popup()
	
func _on_BossImage_button_down():
	file_dialog_boss.popup()
	



func _on_FileDialogBoss_dir_selected(dir):
	pass # Replace with function body.
