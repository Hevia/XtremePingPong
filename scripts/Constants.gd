class_name Constants

enum Teams {
	None = 0,
	Player = 1,
	Enemies = 2,
	World = 3, # Only used for deleting objects
}

const TeamColors = {
	Teams.None: Color.ORANGE,
	Teams.Player: Color.BLUE,
	Teams.Enemies: Color.RED,
	Teams.World: Color.WHEAT
}
