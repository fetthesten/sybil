extends Node

enum statuses {
	opening,	# dialogue panel is being opened for display
	drawing,	# text is being drawn to the panel
	breaking,	# looking for space in order to break dialogue into new panel
	waiting,	# waiting for user input to continue drawing
	input,		# waiting for choice or other input
	branching,	# evaluating input and choosing next node
	closing		# dialogue panel is being closed
}

# types of dialogue node
# each node is an entry into the 'nodes' graph dict
# nodes always have the following members:
#	- text; 	text to display or stat/data/flag to compare/get/set/check 
#	- next: 	next node id(s), array - if node type includes "choice" each of these represent a choice that will be displayed, otherwise the next node will be chosen randomly from each possibility
#	- type:		'types' enum indicating type of node, see below
# optional members:
#	- value: 	number/text to increment/decrement/set stat/data (default is 1)
#	- op:		operation for set/get/check, can be gt lt eq or combination (comparison), inc, dec, set (assignment) (default is gt and inc respectively)

enum types {
	start,		# a starting node, this needs to be called "start"
	text,		# just text, or pipe-delimited choices for choice_mul nodes (does nothing for yes/no or end nodes)
	choice_yn,	# make the player decide between yes or no
	choice_mul,	# make the player decide between several different custom options
	data_get,	# get global data and set a local variable to replace in dialogue graph
	data_set,	# set global data
	flag_check,	# branch depending on flag check
	flag_set,	# set a flag
	stat_check,	# check a player stat
	stat_set,	# set a player stat
	item_add,	# give the player an item
	item_sub,	# take an item from the player
	end			# end dialogue
}

# dialogue node graph dict
# todo: support more than one dialogue graph

var scripts = {}
var current_script
var current_node
var dialogue_initiated = false

func _ready():
	# hide dialogue panel
	gui_hide_dialogue_panel()
	
	# load a dialogue file and initialize nodes
	var file = File.new()
	file.open("res://dat/dialogue/test_dialogue_2.js", file.READ)
	var dat = JSON.parse(file.get_as_text())
	file.close() 
	print(dat)
	
#	if dat.error == 0:
#		nodes = dat.result['nodes']
#		#picture = load(dat.result['picture'])
#		first_nodes = dat.result['first_nodes']
#		Main.addflags(dat.result['flags'])

func _process(delta):
	# processes a dialogue graph if dialogue is initiated
	# current_node needs to be set by dialogue_initiate before doing this
	if dialogue_initiated:
		if typeof(current_node) == TYPE_OBJECT:
			# node is currently being processed
			current_node = current_node.resume()
		else:
			# done processing, get next node
			process_node(scripts[current_script][current_node])

func dialogue_initiate(script):
	# triggers dialogue processing
	dialogue_initiated = true
	current_script = script
	current_node = scripts[script]['start']
	pass
	
func dialogue_end():
	# ends dialogue and stops processing
	dialogue_initiated = false
	pass

func dialogue_process_node(node):	
	# yields progression through a node and returns next node id when done
	match node.type:
		types.start:
			# starting node of script, used as nothing more than a placeholder - just find the next node
			return node.next

func gui_hide_dialogue_panel():
	$TextShadow.hide()
	$TextContent.hide()
	$GUI/DialogueBackground.hide()

func dialogue_increment():
#	if dialogue_current_index <= dialogue_current_string.length():
#		$DialogueText/TextContent.text = dialogue_current_string.substr(dialogue_current_offset, dialogue_current_index)
#		$DialogueText/TextShadow.text = dialogue_current_string.substr(dialogue_current_offset, dialogue_current_index)
#		dialogue_current_index+=1
#		if $DialogueText/TextContent.text.length() >= 700: # magic number that fits the textbox size i used during testing
#			break_dialogue = true
#
#		if break_dialogue:
#			if dialogue_current_string.substr($DialogueText/TextContent.text.length(), 1) == ' ':
#				dialogue_current_offset += $DialogueText/TextContent.text.length() + 1
#				dialogue_current_index = 0
#				break_dialogue = false
	pass