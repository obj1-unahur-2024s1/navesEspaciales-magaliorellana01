class Nave {
	var property velocidad = 0
	var property direccion = 0//entre -10 y 10
	var property combustible
	
	method acelerar(cuanto){
		velocidad = 100000.min(velocidad + cuanto)
	}
	
	method desacelerar(cuanto){
		velocidad = 0.max(velocidad + cuanto)
	}
	
	method irHaciaElSol(){
		direccion = 10
	}
	
	method escaparDelSol(){
		direccion = -10
	}
	
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion + 1)
	}
	
	method alejarseUnPocoDelSol(){
		direccion = -10.max(direccion - 1)
	}
	
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method cargarCombustible(litros){
		combustible = combustible + litros
	}
	method descargarCombustible(litros){
		combustible = combustible - litros
	}
	
	method estaTranquila(){
		return combustible >= 4000 and velocidad < 12000
	}
	
	method recibirAmenaza()
	method estaEnRelajo(){
		return self.estaTranquila()
	}
}


class NaveBaliza inherits Nave{
	var color
	var cambiosHechos = 0
	method cambiarColorDeBaliza(colorNuevo){
		color = colorNuevo
		cambiosHechos += 1
	}
	
	override method prepararViaje(){
		self.cambiarColorDeBaliza("verde")
	}
	
	override method estaTranquila(){
		return super() and color != "rojo"
	}
	
	override method recibirAmenaza(){
		self.irHaciaElSol()
		self.cambiarColorDeBaliza("rojo")
	}
	override method estaEnRelajo(){
		return super() and cambiosHechos == 0
	}
}

class NaveDePasajeros inherits Nave{
	var property cantidadDePasajeros = 0
	const cantidadRacionComida = []
	const  cantidadRacionBebida = []
	const comidaServida = []
	
	method agregarComida(cantidad){
		cantidadRacionComida.add(cantidad)
	}
	
	method descargarComida(cantidad){
		if(cantidadRacionComida.contains(cantidad)){
			cantidadRacionComida.remove(cantidad)
		}
		comidaServida.add(cantidad)
	}
	
	method agregarBebida(cantidad){
		cantidadRacionBebida.add(cantidad)
	}
	
	method descargarBebida(cantidad){
		if(cantidadRacionBebida.contains(cantidad)){
			cantidadRacionBebida.remove(cantidad)
		}
	}
	
	override method prepararViaje(){
		self.agregarComida(4 * cantidadDePasajeros ) 
		self.agregarBebida(6 * cantidadDePasajeros) 
		self.acercarseUnPocoAlSol()
	}
	
	override method recibirAmenaza(){
		velocidad = velocidad*2
		self.descargarComida(1 * cantidadDePasajeros)
		self.descargarBebida(2 * cantidadDePasajeros)
	}
	
	override method estaEnRelajo(){
		return comidaServida.size() <= 50
	}
	
	
}

class NaveDeCombate inherits Nave{
	var estaInvisible = true
	var estanDesplegados = true
	const mensajes = [""]
	
	method ponerseVisible(){
		 estaInvisible = false
	}
	
	method ponerseInvisible(){
		 estaInvisible = true
	}
	
	method estaInvisible(){
		return estaInvisible
	}
	
	method desplegarMisiles(){
		estanDesplegados = true
	}
	
	method replegarMisiles(){
		estanDesplegados = false
	}
	
	method misilesDesplegados(){
		return estanDesplegados
	}
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos(){
		mensajes.size()
	}
	
	method primerMensajeEmitido(){
		mensajes.first()
	}
	
	method ultimoMensajeEmitido(){
		mensajes.last()
	}
	
	method esEscueta(){
		return mensajes.all({m => m.size() < 30})
	}
	
	method emitioMensaje(mensaje){
		mensajes.contains(mensaje)
	}
	
	override method prepararViaje(){
		self.ponerseInvisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision")
		
	}
	override method estaTranquila(){
		return super() and not self.misilesDesplegados()
	}
	override method recibirAmenaza(){
		self.irHaciaElSol()
		self.irHaciaElSol()
		self.emitirMensaje("amenzada recibida")
	}
	
	override method estaEnRelajo(){
		return super() and self.esEscueta()
	}
}

class NaveHospital inherits NaveDePasajeros{
	var tienePreparadosQuirofanos = true
	
	method tienePreparadoQuirofanos(){
	   tienePreparadosQuirofanos = true
	}
	
	method desactivarQuirofano(){
		tienePreparadosQuirofanos = false
	}
	
	method tieneQuirofanoListo(){
		return tienePreparadosQuirofanos
	}
	
	override method estaTranquila(){
		return not self.tieneQuirofanoListo()
	}
	
	override method recibirAmenaza(){
		super()
		self.tienePreparadoQuirofanos()
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
	override method estaTranquila(){
		return super() and not self.estaInvisible()
	}
	override method recibirAmenaza(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
		
	}
}
