abstract sig Vehicle {}

sig Car extends Vehicle{
	drives: one Transmission,
	powered: one Engine 
}

sig Engine {}
sig Transmission {}

pred show (c: Car) {
  p[]
}

pred p() {
  Car.drives = Transmission
	Car.powered = Engine
}


run show for 3
