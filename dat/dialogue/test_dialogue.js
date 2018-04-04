{
	"first_node_priority": "default,intro_unfamiliar,intro_unfamiliar_first",
	"picture": "res://gfx/gui/gui_head_test.png",
	"data":
	{
		"name":
		{
			"familiar": "Ice Cream Buffet",
			"default": "Some Rando"
		}
	},
	"flags":
	{
		"familiar": "false",
		"not_first": "false"
	},
	"dialogue":
	{
		"intro_unfamiliar_first": { "text": "Why, hello, friend! Are you lost, perchance? Forsooth! Prithee, tell me thy name!!!!! lolz!!!!", "setflags": "not_first", "replies": "tell_name,goodbye" },
		"intro_unfamiliar": { "text": "Hello again, curious stranger!! tel me ur naem plz lolz!!!!!!", "checkflags": "not_first", "replies": "tell_name,goodbye" },
		"default": { "text": "LOLZ!!!", "checkflags": "familiar,not_first", "replies": "goodbye" },
		"told_name": { "text": "What a splendid name!!! Indeeeeeeed!!!!! Verily!!!!!!!!!!!! My name is {name}!!!! FORSOOOOOOOOOOOTH!!!!", "replies": "goodbye" }
	},
	"replies":
	{
		"tell_name": { "id": "tell_name", "text": "OMIGOSH yaas queen my name is Donald J. Trump!!", "response": "told_name", "setflags": "familiar" },
		"goodbye": { "id": "goodbye", "text": "lol bye", "response": "default", "end": "true" }
	}
}