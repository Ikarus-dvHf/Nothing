extends VBoxContainer

onready var file_dialog_player= $FileDialogPlayer
onready var file_dialog_boss= $FileDialogBoss

func _ready():
	if(!Global.readme()):
		$InitiliseConfig.visible=false
		return
	var file = File.new()
	$InitiliseConfig.visible=true
	Global.load_config()
	if(!file.file_exists(Global.config_path)):
		$Control.visible = false
		return
	$Control.visible = true	
	
	Global.set_colors(self)
	get_parent().color=Global.background_colors[0]
	get_parent().get_node("background1").modulate=Global.background_colors[1]
	get_parent().get_node("background2").modulate=Global.background_colors[2]
	get_parent().get_node("Title").visible= Global.config.get_value("config_stuff","show_title", false)
			
func _input(event):
	if event.is_action_pressed("RELOAD")&& !Global.config.get_value("config_stuff","disallow_reload_with_F5",true):
		get_tree().reload_current_scene()

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
	Global.player_image=ImageTexture.new()
	var im =Image.new()
	im.load(path)
	Global.player_image.create_from_image(im)
	if im.get_width()!=256 ||  im.get_height()!=256:
		Global.player_image =null
		printerr("Wrong Image size")
		
		
func _on_FileDialogBoss_file_selected(path):
	Global.boss_image=ImageTexture.new()
	var im=Image.new()
	im.load(path)
	Global.boss_image.create_from_image(im)
	if im.get_width()!=256 ||  im.get_height()!=256:
		Global.boss_image =null
		printerr("Wrong Image size")

func _on_PlayerImage_button_down():
	file_dialog_player.popup()
	
func _on_BossImage_button_down():
	file_dialog_boss.popup()
