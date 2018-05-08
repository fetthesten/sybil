extends Node2D

var interaction_icons

var dialogue_current_string = 'Totally awesome. That is for sure. At least I think so. Do you think so too? How delightful! Let us rejoice at how wonderful, awesome and enjoyable this all is. But, also, let us not forget all the hardships we have faced together. These hardships which, upon being faced and subsequently conquered, made us who we are today, in some mysterious way which is both tangible, yet impossible to accurately define. This is the greatest song in the world. Tribute. A long time ago, me and Kyle, we were hitch-hiking down a long and lonesome road. All of a sudden, there shined a shiny demon, in the middle of the road. And he said: "Play the best song in the world, or I\'ll eat your souls." And me and Kyle, we looked at each other, and we each said: "Okay." And so we played the first thing that came into our heads, which just so happened to be the best song in the world, it was the best song in the world. Look into my eyes and it\'s easy to see, one and one makes two, two and one make three, it was destiny.'
var dialogue_current_offset = 0
var dialogue_current_index = 0

func _ready():
	$DebugText.text = ''
	# set up dialogue
	
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

