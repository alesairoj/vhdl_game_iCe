# vhdl_game_iCe

Resumen del proyecto:

El videojuego consta de un personaje que controla el jugador cuyo objetivo es esquivar los obstáculos que le van apareciendo por la pantalla.

Está organizado en los siguientes archivos:

+ top.vhd:

Bloque más alto de la jerarquía, que gestiona los distintos relojes, así como las entradas de los botones y las señales RGB.

+ vgadriver.vhd:

Se encarga de transmitir las señales del protocolo VGA para poder pintar en la pantalla.

+ cuadrado.vhd:

Es el bloque que maneja el jugador, el que aparece en la parte de abajo de la pantalla.

+ enemigo.vhd:

Los enemigos que van apareciendo por la parte de arriba de la pantalla.

+ selector.vhd:

Bloque que detecta las colisiones y multiplexa las señales que se dirigen al vgadriver para poder pintarlo todo.

+ dibuja.vhd:

Bloque orginal de enemigo y cuadrado (estos dos son forks de dibuja)

+ contador.vhd:

Contador simple para poder mover los elementos de la pantalla.

+ ctud.vhd:

Contador mejorado, con sentido de cuenta y saturación.
