module base_transmission_model

sig Time {} 

sig Gear {
	nextGear: lone Gear,
	previousGear: lone Gear
}

one sig Transmission {
	currentGear: Time -> lone Gear
}

fact connected {
	all g: Gear | Gear in g.^nextGear
	all g: Gear | Gear in g.^previousGear
}

pred init (t: Time) {

}

pred noSameGear {
	all g: Gear |	g.nextGear !in g.previousGear
}

pred show {
	noSameGear
}

run show

