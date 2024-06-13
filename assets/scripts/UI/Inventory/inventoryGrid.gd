extends GridContainer

func clicked(slot:PanelContainer, isHand:bool):
	get_parent().clicked(get_children().find(slot, 0), isHand)
