extends Node

# main game manager script
# eventually this will be the glue that holds the game together and helps other scripts
# check and trade data back and forth

# gui stuff
# res = the resource to preload
# instance = the in-game instance accessed by scripts and such
var gui = {
	'health_indicator': { 'res': preload('res://gui/HealthIndicator.tscn'), 'instance': null, },
	}

func _ready():
	load_gui()

func _process(delta):
	pass
	
func load_gui():
	for element in gui.keys():
		print(gui[element])
		gui[element].instance = gui[element].res.instance()
		GUI.add_child(gui[element].instance)
		
func testglobal():
	print('globalization')