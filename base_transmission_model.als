module base_transmission_model

sig Time, Shiftpoints, Breakpoints, ThrottleBPoints {} 

sig Gear {
	//Has next and previous gear relations
	//TODO: Need to do restrictions on next/previous for first and last gear to point 
	// to self.
	nextGear: lone Gear,
	previousGear: lone Gear,
	shiftUp: one Shiftpoints,
	shiftDown: one Shiftpoints
}

one sig ShiftSchedule {
	threshold: set Shiftpoints
	//A shiftschedule is made up of a set of shift points
}

one sig VehicleSpeed {
	vsBreakpoints: seq Breakpoints
	//Vehicle speed is a singular point input.
	//Triggers certain VS based breakpoints.
}

one sig ThrottleInput {
	throttlebreakpoints: seq ThrottleBPoints
	//Throttle as a singular point input.
	//composed of breakpoints of throttle input.
}

one sig BrakeInput {
	pressed: set BrakeInput
	//Attempt at a simplified relation (trying for no boolean)
}

fun getAllBreakpoints [b: seq Breakpoints] : set Breakpoints{
    univ.b
}

one sig Transmission {
	gears: set Gear,
	//currentGear: gears one -> Time,
	restricted: ShiftSchedule
	//Base Transmission signature.
	//Composed of a set of gears (maybe a sequence in future?)
	//only allowed one currentGear at a time.
}

fact connected {
	all g: Gear | Gear in g.^nextGear
	all g: Gear | Gear in g.^previousGear
	//Every Gear has a previous and nextgear, and is reachable through
	//those relations somehow.
}

fact limitedGearsBySchedule {
	all t: Transmission | (Shiftpoints in t.gears.shiftUp) && (Shiftpoints in t.gears.shiftDown)
}


pred noSameGear {
	all g: Gear |	g.nextGear !in g.previousGear
	//Says that no nextgear can be the same as its previous gear.  
	//This could be a problem, as it can restrict things such as first gear.
}

pred restrictedGearBox (t: Transmission) {
	//Says that the atoms of shiftschedules and shiftpoints reside in the Transmission
	// and cannot be "loose" atoms in the world.
	all s: ShiftSchedule | s in t.restricted
	all p: Shiftpoints | p in t.restricted.threshold
	all g: Gear | g in t.gears
}

fun shiftUp [t: Transmission] : set Gear {
	//Needs Threshold interaction here.
	t.gears.nextGear
}

pred show {
	all t: Transmission | noSameGear && restrictedGearBox[t] 
	//Display with the following restrictions.  
}

run show for 1 but 6 Gear

