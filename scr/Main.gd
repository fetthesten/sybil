extends Node

# main game manager script
# eventually this will be the glue that holds the game together and helps other scripts
# check and trade data back and forth

var DEBUG = false

# player and game stats are placed here for convenience when saving&loading
var playerStats = {
	'name': 'ParticipantAnonymous',
}

func _ready():
	DEBUG = OS.is_debug_build()
