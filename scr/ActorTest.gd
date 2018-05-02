extends Spatial

var first_node_priority
var picture
var dialogue = {}
var replies = {}
var data = {}
var flags = {}

# testing stuff because stationary stuff is booooring
var mdl
var heh

func _ready():
	var file = File.new()
	file.open("res://dat/dialogue/test_dialogue.js", file.READ)
	var dat = JSON.parse(file.get_as_text())
	file.close() 

	if dat.error == 0:
		first_node_priority = dat.result['first_node_priority']
		picture = load(dat.result['picture'])
		dialogue = dat.result['dialogue']
		replies = dat.result['replies']
		data = dat.result['data']
		flags = dat.result['flags']
		
		for flag in flags.keys():
			flags[flag] = false # flags always start out as false and can only be set, never unset
	
	dialogue['error'] = { 'text': 'ERROR', 'replies': 'none' }
	
	mdl = $"MeshInstance"
	heh = 0

func _process(delta):
	#yeah... just to have a simple effect to look at while testing
	heh += delta
	mdl.translation.y = 2.5 + sin(heh)
	mdl.rotation.y = heh

func BodyEnter(body):
	if body.name == "Player":
		body.SetDialogueTarget(self)

func BodyExit(body):
	if body.name == "Player":
		body.SetDialogueTarget(null)

func GetPicture():
	return picture

func ProcessDialogue(index):
	if index == 'none':
		# first interaction
		index = first_node_priority
	else:
		# index is an entry in the replies dict
		SetFlags(replies[index])
		if replies[index].has('end'):
			return { 'text': 'end' }
		index = replies[index]['response']
	var node = dialogue[ResolveNodes(index, 'dialogue')].duplicate()
	SetFlags(node)
	# insert replies and replace tokens
	var d = {}
	for item in data:
		d[item] = ResolveData(item)
	var r = ResolveNodes(node['replies'], 'replies')
	node['replies'] = []
	for reply in r:
		node['replies'].append({ 'id': reply['id'], 'text': reply['text'].format(d) })
	node['text'] = node['text'].format(d)
	
	return node

func ResolveNodes(query, type):
	if type == 'dialogue':
		if query.find(',') == -1:
			return query
		var indices = query.split(',')
		for index in indices:
			if not dialogue[index].has('checkflags'):
				return index
			if CheckFlags(dialogue[index]['checkflags']):
				return index
	else:
		var results = []
		var indices = query.split(',')
		for index in indices:
			if not replies[index].has('checkflags'):
				results.append(replies[index])
			elif CheckFlags(replies[index]['checkflags']):
				results.append(replies[index])
		return results
	return 'error'

func ResolveData(query):
	for checkflags in data[query].keys():
		if checkflags != 'default':
			if CheckFlags(checkflags):
				return data[query][checkflags]
		else:
			return data[query][checkflags]

func CheckFlags(query):
	var f = query.split(',')
	var allFlagsChecked = true
	for flag in f:
		if not flags[flag]:
			allFlagsChecked = false
	return allFlagsChecked

func SetFlags(node):
	if node.has('setflags'):
		var setflags = node['setflags'].split(',')
		for flag in setflags:
			flags[flag] = true

func GetActorName():
	return ResolveData('name')