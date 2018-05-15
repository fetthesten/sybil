extends Node2D

var interaction_icons

func _ready():
	$DebugText.text = ''
	
	#set up interaction icons
	interaction_icons =	{
		'talk': preload('res://gfx/gui/talk_prompt.png'),
	}
	
func set_debug_info(info):
	if Main.DEBUG:
		$DebugText.text = info
		
func set_interaction_icon(icon = 'none'):
	if icon in interaction_icons.keys():
		$InteractionIcon.texture = interaction_icons[icon]
	elif icon == 'none':
		$InteractionIcon.texture = null