module base_transmission_model

sig Time, Shiftpoints, Breakpoints, ThrottleBPoints {} 

abstract sig Gear {
	//Has next and previous gear relations
	//TODO: Need to do restrictions on next/previous for first and last gear to point 
	// to self.
	nextGear: lone Gear,
	previousGear: lone Gear,
	shiftUp: one Shiftpoints,
	shiftDown: one Shiftpoints
}
one sig GearR extends Gear {}
one sig Gear1 extends Gear {}
one sig Gear2 extends Gear {}
one sig Gear3 extends Gear {}
one sig Gear4 extends Gear {}
one sig Gear5 extends Gear {}

fact gearRelations { //Change to predicates to demonstrate how assertions can break them
	GearR.nextGear = Gear1
	GearR.previousGear = GearR
	Gear1.nextGear = Gear2
	Gear1.previousGear = GearR
	Gear2.nextGear = Gear3
	Gear2.previousGear = Gear1
	Gear3.nextGear = Gear4
	Gear3.previousGear = Gear2
	Gear4.nextGear = Gear5
	Gear4.previousGear = Gear3
	Gear5.nextGear = Gear5
	Gear5.previousGear = Gear4
}
one sig ShiftSchedule {
	threshold: set Shiftpoints
	//A shiftschedule is made up of a set of shift points
}

one sig S1 extends Shiftpoints {}
one sig S2 extends Shiftpoints {}
one sig S3 extends Shiftpoints {}
one sig S4 extends Shiftpoints {}
one sig S5 extends Shiftpoints {}
one sig ShiftFloor extends Shiftpoints {}
one sig ShiftCeiling extends Shiftpoints {}

fact shiftRelations {//Change to predicates to demonstrate how assertions can break them
	GearR.shiftUp = S1
	Gear1.shiftUp = S2
	Gear2.shiftUp = S3
	Gear3.shiftUp = S4
	Gear4.shiftUp = S5
	Gear5.shiftUp = ShiftCeiling
	GearR.shiftDown = ShiftFloor
	Gear1.shiftDown = S1
	Gear2.shiftDown = S2
	Gear3.shiftDown = S3
	Gear4.shiftDown = S4
	Gear5.shiftDown = S5
	
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
	//all g: Gear | Gear in g.^nextGear
	//all g: Gear | Gear in g.^previousGear
	//Every Gear has a previous and nextgear, and is reachable through
	//those relations somehow.

	//Note* Fact is too strong, prevents gears from having cycles if topped or bottomed out.
}

fact limitedGearsBySchedule {
	//all t: Transmission | (Shiftpoints in t.gears.shiftUp) && (Shiftpoints in t.gears.shiftDown)
	//*Note Limit is too strong, prevents shiftpoints from existing standalone.
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
	all g: Gear | g in t.gears// This needs to be a fact
}

fun shiftUp [t: Transmission, g: Gear] : set Gear {
	//Needs Threshold interaction here.
	t.gears.nextGear
}

assert everyShiftUpDefined {
	all t: Transmission, g: Gear | t.gears in shiftUp[t,g] && show
}

pred show {
	all t: Transmission | noSameGear && restrictedGearBox[t]
//Display with the following restrictions.  
}

//check  everyShiftUpDefined

run show for 1

