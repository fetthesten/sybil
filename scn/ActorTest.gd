extends Spatial

export (Texture) var HEADSHOT
export (String) var UNFAMILIAR_NAME
export (String) var FAMILIAR_NAME

var dialogue = {}
var replies = {}

var mdl
var heh

# flags
var flags = {}

func _ready():
	mdl = $"MeshInstance"
	
	flags['familiar'] = false
	flags['not_first'] = false
	
	dialogue['intro_unfamiliar_first'] = { 'text': 'Why, hello, friend! Are you lost, perchance? Forsooth! Prithee, tell me thy name!!!!! lolz!!!!', 'replies': 'tell_name,goodbye' }
	dialogue['intro_unfamiliar'] = { 'text': 'Hello again, curious stranger!! tel me ur naem plz lolz!!!!!!', 'replies': 'tell_name,goodbye' }
	dialogue['told_name'] = { 'text': 'What a splendid name!!! Indeeeeeeed!!!!! Verily!!!!!!!!!!!! My name is ' + FAMILIAR_NAME + '!!!! FORSOOOOOOOOOOOTH!!!!', 'replies': 'goodbye' }
	dialogue['default'] = { 'text': 'LOLZ!!!', 'replies': 'goodbye' }
	
	replies['tell_name'] = { 'id': 'tell_name', 'text': 'OMIGOSH yaas queen my name is Donald J. Trump!!', 'response': 'told_name', 'triggers': 'setflag:familiar' }
	replies['goodbye'] = { 'id': 'goodbye', 'text': 'lol bye', 'response': 'default', 'triggers': 'end' }
	
	heh = 0

func _process(delta):
	heh += delta
	mdl.translation.y = 2.5 + sin(heh)
	mdl.rotation.y = heh

func BodyEnter(body):
	if body.name == "Player":
		body.SetDialogueTarget(self)

func BodyExit(body):
	if body.name == "Player":
		body.SetDialogueTarget(null)

func GetHeadshot():
	return HEADSHOT

func GetDialogue(index):
	if index == 'none':
		if not flags['not_first']:
			if not flags['familiar']:
				flags['not_first'] = true
				return dialogue['intro_unfamiliar_first']
		else:
			if not flags['familiar']:
				return dialogue['intro_unfamiliar']
			else:
				return dialogue['default']
	
	else:
		var triggers = replies[index]['triggers']
		if triggers != 'none':
			triggers = triggers.split(',')
			for trigger in triggers:
				trigger = trigger.split(':')
				if trigger[0] == 'setflag':
					flags[trigger[1]] = true
				if trigger[0] == 'end':
					return { 'text': 'end', 'replies': 'none' }
		
		return dialogue[replies[index]['response']]

func GetReplies(indices):
	indices = indices.split(',')
	
	var results = []
	for index in indices:
		results.append(replies[index])
	return results

func GetActorName():
	return FAMILIAR_NAME if flags['familiar'] else UNFAMILIAR_NAME