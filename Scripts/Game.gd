extends Control
var t1=["The","A"]
var t2=["most ","somewhat ","least ","","","greatest "]
var t3=["different","important","popular","basic","difficult","known","useful","mental",
		"emotional","political","unhealthy","significant","cute","expensive","successful",
		"poor","helpful","recent","impossible","legal","dangerous","famous"]
var t4=["fight","battle","duel","brawl","conflict","dispute","feud","skirmish","struggle","quest",
		"adventure","pursit","hunt"]
		
export (Array, Image) var dice_images
onready var player_dice =[get_node("Player/game/1"),get_node("Player/game/2"),get_node("Player/game/3")]
onready var boss_dice =[get_node("Boss/game/1"),get_node("Boss/game/2"),get_node("Boss/game/3")]

var rng =RandomNumberGenerator.new()
func _input(event):
	if event.is_action_pressed("RELOAD")&& !Global.config.get_value("config_stuff","disallow_reload_with_F5",true):
		Global.resize()
		get_tree().reload_current_scene()
		

func _ready():
	rng.randomize()
	get_node("Player/PlayerImage").texture=Global.player_image
	get_node("Boss/BossImage").texture=Global.boss_image
	if(Global.config.get_value("config_stuff","hash_names",false)):
		get_node("Player/Border/PlayerName").text=String(Global.player_name.hash())
		get_node("Boss/Border/BossName").text=String(Global.boss_name.hash())
	else:
		get_node("Player/Border/PlayerName").text=Global.player_name		
		get_node("Boss/Border/BossName").text=Global.boss_name
	generate_title()
	reset_dice()
	roll()
	
func reset_dice():
	for i in range (0,player_dice.size()):
		player_dice[i].texture=dice_images[0]
	for i in range (0,boss_dice.size()):
		boss_dice[i].texture=dice_images[0]	


		
func roll():
	var player_roll=[]
	var boss_roll=[]
	var a=0
	var b=0
	reset_dice()
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
	var p_att=0
	var p_magic=0
	var p_def=0
	var b_att=0
	var b_magic=0
	var b_def=0
	for i in player_roll:
		if i==1:
			p_att<<1
			p_att+=1
		elif i==2:
			p_magic+=1
		elif i==3:
			p_def+=1
	for i in player_roll:
		if i==1:
			b_att<<1
			b_att+=1
		elif i==2:
			b_magic+=1
		elif i==3:
			b_def+=1
	# hpb-=max(p_att-b_def,0)+p_magic
	# hpp-=max(b_att-p_def,0)+b_magic		
			
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
	title+=" of "
	title+= Global.player_name	
	title+=" and "
	title+= Global.boss_name	
	$Title.text=title			
	

func _on_Roll_button_down():
	#TODO multiple rools ?
	roll()
