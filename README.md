# :blue_heart: Juego Tetris Clásico: Estructurada :blue_heart:
Proyecto de Tetris en programación estructurada para la clase de POO de la Universidad Nacional de Colombia

## Objetivo:
Repasar los conceptos básicos de la programación estruturada mediante la implementacioón de un código de un juego de tetris clásico.

## Notas sobre desarollo:
<p>Esta aplicación de tetris se desarrolló usando la API de processing. El código que se encuentra en este repositorio fue implementado en el IDE de procesing, por lo que se recomienda usar este entorno para correr el APPlet y evitar inconvenientes.</p>

<p>La protagonista principal en esta implementación del tetris es la matriz de memoria. La escala esocogida en settings determina las dimensiones de la matriz, ya que esta matriz cubre toda la pantalla mediante un metodo que dibuja un cuadro de tamaño escala sobre la pantalla por cada celda de la matriz.De este modo, la matriz de memoria se convierte en un sistema de coordenadas escalado con el cual se pueden dibujar cuadrados sobre la pantalla.Ya que los tetrominos y el tablero se basan en cuadrados como sus divisiones mas pequeñas, este método permite dibujar todos los tetrominos al sobreescribir la matriz de memoria siguiendo patrones especificos de coordenadas. Un método que convierte enteros a colores permite cambiar el color de los cuadrados dibujados en pantalla según el número asignado a cada celda de la matriz de memoria. Toda la interfaz gráfica de la pantalla principal de juego, incluyendo los tetrominos y sus desplazamientos, se realiza sobreescribiendo los enteros dentro de la matriz de memoria, excepto los textos que por conveniencia se escribieron usando la API de processing.</p>
<p>Esta superposicon de memoria e interfaz gráfica permitió guardar las posiciones de cada tetromino despues de cada colisión y dibujarlos en pantalla sin necesidad de usar arreglos dinamicos o métodos separados para dibujarlos. También facilitó la deteccción de colisiones ya que estas se redujeron a ver si los espacios objetivo, ahora celdas de la matriz, tenian valores enteros diferentes a 0, el valor por default, en vez de comparar colores o coordenadas en pantalla. Sin embargo, un defecto de este método es el hecho de que cada rotacion del teromino, como cada caso de colisión tuvo que ser especificado accediendo explicitamente a las celdas de la matriz de memoria.</p>

## Especificaciones del Juego
EL Juego solo cuenta con tres pantallas.
### Pantalla Principal de Juego
<p>La pantalla donde occurre la acción y a la cual te envia la aplicación apenas la inicias.</p>
<p>Esta pantalla consta del tablero de juego, donde obvamente los tetrominos pueden ser movidos a voluntad usando las flechas del teclado, un cuadro que te muestra el siguiente tetromino a aparecer, un cuadro que te muestra tu puntaje actual, y un cuadro que te muestra el nivel en el que estas. Hay un total de 4 niveles que correspondeen a cuatro aceleraciones de descenso mayores a la anterior. El nivel aumenta después de cierta cantidad de tiempo.</p>
### Controles de Juego
<p>Las flechas izquierda (LEFT ARROW)) y derecha (RIGHT ARROW) sirven para mover el tetromino en juego hacia la dirección especificada por la flecha.<br>
La felcha de arriba (UP ARROW) sirve para rotar el tetromino en dirección horaria.<br>
La flecha inferior (DOWN ARROW) sirve para aumentar la velocidad de descenso del tetromino en juego; tener en cuenta que esto aumenta tu puntaje de juego.<br>
La barra espacioadora (SPACE) permite pausar el juego y abre la interzas de pausa.<br>
La tecla SHIFT permite visualizar los valores de la matriz de memoria en tiempo real que corresponde a la porcion de la pantlla donde se muestra el tablero de juego.</p>

### Menu de Pausa.
Aqui te muestra tu puntaje actual y te deja Reanudar el juego oprimiendo SPACE, o reiniciarlo oprimiendo SHIFT.

### Game Over
En esta pantalla se muestra tu puntaje Final, y te deja Iniciar u Nuevo juego Oprimiendo la tecla SPACE.

