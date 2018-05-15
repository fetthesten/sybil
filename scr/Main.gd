extends Node

# main game manager script
# eventually this will be the glue that holds the game together and helps other scripts
# check and trade data back and forth

var DEBUG = false

enum game_states {
	playing,	# normal gameplay state
	pause,		# the game is paused
	inventory,	# the player is interacting with the gui
	dialogue	# the player is in dialogue
}

var menu_enabled = false

# player and game stats are placed here for convenience when saving&loading
var player_stats = {
	'name': 'ParticipantAnonymous',
}

var flags = {}

var game_state

func _ready():
	DEBUG = OS.is_debug_build()
	game_state = game_states.playing

func addflags(flag_args):
	if typeof(flag_args) is TYPE_STRING:	# comma-delimited string
		flag_args = flag_args.split(',')
	for flag in flag_args:
		flags[flag] = false

func setflags(flag_args):
	if typeof(flag_args) is TYPE_STRING:	# comma-delimited string
		flag_args = flag_args.split(',')
	for flag in flag_args:
		flags[flag] = true

func checkflag(flag):
	return flags[flag]		