extends Control
var t1=["The","A"]
var t2=["most ","somewhat ","least ","","","greatest "]
var t3=["different","important","popular","basic","difficult","known","useful","mental",
		"emotional","political","unhealthy","significant","cute","expensive","successful",
		"poor","helpful","recent","impossible","legal","dangerous","famous"]
var t4=["fight","battle","duel","brawl","conflict","dispute","feud","skirmish","struggle","quest",
		"adventure","pursit","hunt"]
		
export (Array, Image) var dice_images
onready var player_dice =[get_node("Player/game/1"),get_node("Player/game/2")]
onready var boss_dice =[get_node("Boss/game/1"),get_node("Boss/game/2"),get_node("Boss/game/3")]

var rng =RandomNumberGenerator.new()

var player_add_dice=false
var boss_add_dice=false
var player_add_damage=0
var boss_add_damage=0
var boss_defeatable=false


func _input(event):
	if event.is_action_pressed("RELOAD")&& !Global.config.get_value("config_stuff","disallow_reload_with_F5",true):
		get_tree().reload_current_scene()
		

func _ready():
	Global.load_config()
	Global.set_colors(self)
	$ColorRect/background1.modulate=Global.background_colors[1]
	$ColorRect/background2.modulate=Global.background_colors[2]
	rng.randomize()
	get_node("Player/PlayerImage").texture=Global.player_image
	get_node("Boss/BossImage").texture=Global.boss_image
	if(Global.config.get_value("config_stuff","hash_names",false)):
		get_node("Player/PlayerName").text=String(Global.player_name.hash())
		get_node("Boss/BossName").text=String(Global.boss_name.hash())
	else:
		get_node("Player/Border/PlayerName").text=Global.player_name		
		get_node("Boss/Border/BossName").text=Global.boss_name
	generate_title()
	var f= ConfigFile.new()
	var err= f.load(Global.boss_path)
	if(err!=OK):
		return
	boss_add_dice=f.get_value("Ym9zc19kYXRhCg==","QWRkaXRpb25hbF9kaWNl",true)
	print(boss_add_dice)
	if(boss_add_dice):
		boss_dice.append(get_node("Boss/game/4"))
		boss_dice[boss_dice.size()-1].visible=true
	boss_add_damage=f.get_value("Ym9zc19kYXRhCg==","ZXh0cmFfZGFtYWdlX2Ftb3VudA",2)
	if(boss_add_damage<0):
		boss_add_damage=0
	if(boss_add_damage>2):
		boss_add_damage=2
	boss_defeatable=f.get_value("Ym9zc19kYXRhCg==","Ym9zc19kZWZlYXRhYmxl",false)
	err= f.load(Global.player_path)
	if(err!=OK):
		return
	player_add_dice=f.get_value("cGxheWVyX2RhdGE=","QWRkaXRpb25hbF9kaWNl",false);
	if(player_add_dice):
		player_dice.append(get_node("Player/game/3"))
		player_dice[player_dice.size()-1].visible=true
	player_add_damage=f.get_value("cGxheWVyX2RhdGE=","ZXh0cmFfZGFtYWdlX2Ftb3VudA",0);
	if(player_add_damage<0):
		player_add_damage=0
	if(player_add_damage>2):
		player_add_damage=2
	reset_dice()
		
func reset_dice():
	for i in range (0,player_dice.size()):
		player_dice[i].texture=dice_images[0]
		player_dice[i].modulate=Color.black
	for i in range (0,boss_dice.size()):
		boss_dice[i].texture=dice_images[0]	
		boss_dice[i].modulate=Color.black


		
func roll():
	var player_roll=[]
	var boss_roll=[]
	var a=0
	var b=0
	var t=Timer.new()
	t.set_wait_time(0.5)
	self.add_child(t)
	t.start()
	var tmp 
	while(b<boss_dice.size()):
		if(a==b && a<player_dice.size()):
			tmp =rng.randi_range(1,dice_images.size()-1)
			player_roll.append(tmp)
			player_dice[a].texture=dice_images[tmp]
			a+=1
		elif (b<boss_dice.size()):
			tmp =rng.randi_range(1,dice_images.size()-1)
			boss_roll.append(tmp)
			boss_dice[b].texture=dice_images[tmp]
			b+=1	
		yield(t,"timeout")
	resolve(player_roll,boss_roll)
	
func resolve(var player_roll, var boss_roll):
	var dem=0
	for i in range(0,player_roll.size()):
		if player_roll[i]==1:
			player_dice[i].modulate=Color.red
			dem+=1+player_add_damage
	for i in range(0,boss_roll.size()):
		if(boss_roll[i]==3):
			boss_dice[i].modulate=Color.green
			dem = max(dem-2,0)
	$Boss/game/health.value-=dem
	print("Player did damage: "+String(dem))
	if($Boss/game/health.value<=0):
		score()
	dem=0
	for i in range(0,player_roll.size()):
		if player_roll[i]==2:
			player_dice[i].modulate=Color.red
			dem+=1
	$Boss/game/health.value-=dem
	print("Player did Magic damage: "+String(dem))
	if($Boss/game/health.value<=0):
		score()
	dem=0
	for i in range(0,boss_roll.size()):
		if boss_roll[i]==1:
			boss_dice[i].modulate=Color.red
			dem+=1+boss_add_damage
	for i in range(0,player_roll.size()):
		if(player_roll[i]==3):
			player_dice[i].modulate=Color.green
			dem = max(dem-2,0)
	$Player/game/health.value-=dem
	print("Boss did damage: "+String(dem))
	if($Player/game/health.value<=0):
		lose()
	dem=0
	for i in range(0,boss_roll.size()):
		if boss_roll[i]==2:
			boss_dice[i].modulate=Color.red
			dem+=1	
	$Player/game/health.value-=dem
	print("Boss did Magic damage: "+String(dem))	
	if($Player/game/health.value<=0):
		lose()		
			
func generate_title():
	var title=""
	title+= t1[rng.randi_range(0,t1.size()-1)]
	title+=" "
	title+= t2[rng.randi_range(0,t2.size()-1)]
	title+= t3[rng.randi_range(0,t3.size()-1)]
	title+=" and "
	title+= t3[rng.randi_range(0,t3.size()-1)]	
	title+=" "
	title+= t4[rng.randi_range(0,t4.size()-1)]	
	title+=" of\n"
	if(Global.config.get_value("config_stuff","hash_names",false)):
		title+= String(Global.player_name.hash())	
		title+=" and "
		title+= String(Global.boss_name.hash())
	else:
		title+= Global.player_name	
		title+=" and "
		title+= Global.boss_name	
	$Title.text=title			
	


func _on_Roll_button_down():
	print("pressed")
	if($Player/game/Roll.disabled):
		return
	print("rolled")
	$Player/game/Roll.disabled=true
	reset_dice()
	roll()
	$Player/game/Roll.disabled=false
	
func lose():
	$ColorRect/Lost.popup()
	
func score():
	var score=20000
	if(player_add_damage>0):
		score+=2500
	if player_add_dice:
		score+=3028
	if boss_add_dice:
		score +=2690
	if boss_add_damage==2:
		score+=2511
	if Global.player_image!=null:
		score+=18145
	if Global.boss_image!=null:
		score+=12045
	if(Global.config.get_value("config_stuff","hash_names",false)):
		score-=19485
	var def_color=Color("#FFFFFF") 
	if(Global.background_colors[0]!=def_color && Global.background_colors[1]!=def_color 
			&&Global.background_colors[2]!=def_color):
		score+=31918
	if(Global.config.get_value("config_stuff","disallow_reload_with_F5",true)):
		score-=7780
	if(!Global.config.get_value("config_stuff","portrait",true)):
		score-=8750
	if(Global.config.get_value("config_stuff","show_title",false)):
		score+=15800
	var time = OS.get_unix_time()-Global.start_time
	score -=(time*2)
	$ColorRect/Highscore.text="Score: "+String(score)


func _on_Lost_confirmed():
	get_tree().reload_current_scene()
