class_name Constants

enum Teams {
	None = 0,
	Player = 1,
	Enemies = 2,
	World = 3, # Only used for deleting objects
}

const TeamColors = {
	Teams.None: Color.SKY_BLUE,
	Teams.Player: Color.BLUE,
	Teams.Enemies: Color.ORANGE,
	Teams.World: Color.WHEAT
}

const GeneralDeathTips = [
	"Always order Pizza after 5:02pm on Thursdays",
	"Have you tried hitting the ball lol?",
	"Try Thunderstorm to die even more!",
	"Maybe this difficulty is too hard for you?"
]
