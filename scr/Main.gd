extends Node

# main game manager script

# level stuff
var levels = {
	'test level': preload('res://scn/dungeon01_test.tscn'),
	}

# gui stuff
var gui = {
	'health indicator': { 'res': preload('res://gui/HealthIndicator.tscn'), 'instance': null, },
	}

var running = false

func _ready():
	$LevelContainer.add_child(levels['test level'].instance())
	gui['health indicator']['instance'] = gui['health indicator']['res'].instance()
	$GUI.add_child(gui['health indicator']['instance'])

func _process(delta):
	if not running:
		running = true
		print('running')
		print(gui['health indicator'])