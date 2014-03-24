open base_transmission_model

abstract sig Vehicle {}

sig Car extends Vehicle{
	drives: one Transmission,
	powered: one Engine 
}

sig Engine {}

pred show (g: Gear) {
  SingleCar[]
}

pred SingleCar() {
  	Car.drives = Transmission
  	Car.powered = Engine
	one Car
}


run show
