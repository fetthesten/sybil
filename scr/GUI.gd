extends Node2D

var interaction_icons
var dialogue_last_interaction

func _ready():
	# set up dialogue
	$DialogueBackground.hide()
	$DialogueText.hide()
	dialogue_last_interaction = 'idle'
	
	#set up interaction icons
	interaction_icons =	{
		'talk': preload('res://gfx/gui/talk_prompt.png'),
	}

func dialogue_start():
	$DialogueBackground.show()
	$DialogueText.show()
	dialogue_last_interaction = 'none'

func dialogue_end():
	$DialogueBackground.hide()
	$DialogueText.clear()

func dialogue_add_response(img, actor_name, response, replies):
	$DialogueText.add_image(img)
	$DialogueText.append_bbcode('[color=#ff0000]' + actor_name + ':[/color] ' + response)
	$DialogueText.newline()
	
	for reply in replies:
		$DialogueText.append_bbcode('~[color=#ffff00][url=' + reply['id'] + ']' + reply['text'] + '[/url][/color]')
		$DialogueText.newline()

func dialogue_choice(meta):
	var t = $DialogueText.text
	$DialogueText.bbcode_text = t
	dialogue_last_interaction = meta
	
func set_debug_info(info):
	if Main.DEBUG:
		$DebugText.text = info
		
func set_interaction_icon(icon = 'none'):
	if icon in interaction_icons.keys():
		$InteractionIcon.texture = interaction_icons[icon]
	elif icon == 'none':
		$InteractionIcon.texture = null


