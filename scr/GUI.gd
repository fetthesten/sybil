extends Node2D

var interaction_icons

var dialogue_current_string = 'Totally awesome.'
var dialogue_current_index = 0

func _ready():
	$DebugText.text = ''
	# set up dialogue
	$DialogueText/TextDisplay.playback_speed = 5
	
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

func dialogue_test():
	pass

func dialogue_increment_display():
	if dialogue_current_index <= dialogue_current_string.length():
		$DialogueText/TextContent.text = dialogue_current_string.substr(0, dialogue_current_index)
		$DialogueText/TextShadow.text = dialogue_current_string.substr(0, dialogue_current_index)
		dialogue_current_index+=1
