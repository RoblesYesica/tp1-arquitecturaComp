# Trabajo Practico N°1 
## Implementación de una ALU parametrizable en FPGA
Este proyecto consiste en la implementación de una ALU (Unidad Aritmético Lógica) parametrizable en FPGA. Las principales características del proyecto son:
- ALU parametrizable: La ALU se ha diseñado de manera que el bus de datos es parametrizable, lo que permite modificar su tamaño fácilmente para poder ser reutilizada en trabajos futuros.
- Validación con Test Bench: Se ha desarrollado un banco de pruebas (Test Bench) para validar el correcto funcionamiento de la ALU. Este testbench incluye:
-- Generación automática de entradas aleatorias.
-- Código de chequeo automático para verificar los resultados obtenidos.
- Simulación y análisis

## Diagrama de bloques funcional
![Diagrama de bloques](/img/img1.jpg "Diagrama de bloques")
- Los datos de entrada (A y B) y el código de operación (Op) son ingresados mediante un mismo conjunto de interruptores.
- Primero, se ingresa el valor de A presionando un botón específico para confirmar su entrada.
- Luego, se ingresa el valor de B y se presiona otro botón para confirmar este segundo dato.
- A continuación, se selecciona la operación deseada mediante otros interruptores y se presiona otro botón para ejecutar la operación.
- Una vez confirmados los operandos y la operación, el resultado se muestra en los LEDs, proporcionando una salida visual 
- Además, el sistema incluye un botón de reset, que permite restablecer el sistema y limpiar los valores ingresados para realizar nuevas operaciones.
- En el caso de operaciones aritméticas, además del resultado, se indica si hubo o no overflow a través de un LED adicional que se enciende si se detecta esta condición.
- El sistema también incluye un botón de reset, que permite restablecer el sistema y limpiar los valores ingresados para realizar nuevas operaciones.

## Módulos Implementados
### 1-Módulo ALU

Este módulo implementa una Unidad Aritmético Lógica (ALU) parametrizable que puede realizar diversas operaciones aritméticas y lógicas.
##### Parámetros
- `NB_DATA`: Número de bits para los datos de entrada (por defecto 8).
- `NB_OP`: Número de bits para el código de operación (por defecto 6).

##### Entradas
- `i_dataA`: Primer operando (bus de datos).
- `i_dataB`: Segundo operando (bus de datos).
- `i_op`: Código de operación que determina qué operación se va a realizar.

##### Salidas
- `o_result`: Resultado de la operación.
- `o_overflow`: Señal que indica un desbordamiento (overflow) en las operaciones aritméticas.

##### Operaciones Soportadas
- **Aritméticas:**
  - Suma (`ADD`): Código 6'b100000.
  - Resta (`SUB`): Código 6'b100010.
- **Lógicas:**
  - AND (`AND`): Código 6'b100100.
  - OR (`OR`): Código 6'b100101.
  - XOR (`XOR`): Código 6'b100110.
  - NOR (`NOR`): Código 6'b100111.
- **Desplazamientos:**
  - Desplazamiento a la derecha aritmético (`SRA`): Código 6'b000011.
  - Desplazamiento a la derecha lógico (`SRL`): Código 6'b000010.
 
### 2-Módulo ADD_SUB

Este módulo implementa la lógica para realizar operaciones de suma y resta de dos operandos con signo. Está diseñado para trabajar con un tamaño de dato configurable.

##### Parámetros
- `NB_DATA`: Número de bits para los operandos (por defecto 8).

#### Entradas
- `i_dataA`: Primer operando (con signo, rango de -128 a 127 para 8 bits).
- `i_dataB`: Segundo operando (con signo).
- `ctrl`: Control de operación; `0` para suma y `1` para resta.

#### Salidas
- `o_result`: Resultado de la operación, también con signo.
- `o_overflow`: Señal que indica si se ha producido un desbordamiento (overflow).

### 3-Módulo TOP

El módulo `TOP` actúa como la interfaz principal para la ALU, permitiendo la entrada de datos y operaciones mediante interruptores y botones, así como la visualización de resultados y señales de desbordamiento en LEDs.

#### Parámetros
- `NB_DATA`: Número de bits para los datos (por defecto 8).
- `NB_OP`: Número de bits para el código de operación (por defecto 6).

#### Entradas
- `i_dataSw`: Interruptores de entrada para los datos (bus de datos).
- `i_opSw`: Interruptores de entrada para seleccionar la operación.
- `i_btnA`: Botón para cargar `dataA`.
- `i_btnB`: Botón para cargar `dataB`.
- `i_btnO`: Botón para cargar la operación.
- `i_clk`: Señal de reloj.
- `i_reset`: Señal de reinicio.

#### Salidas
- `o_resultLed`: Resultado de la operación, enviado a LEDs.
- `o_overflowLed`: Señal de desbordamiento, enviada a un LED.

#### 4-Módulo de Prueba ALU_TB

El módulo `ALU_TB` es un banco de pruebas diseñado para validar el correcto funcionamiento de la ALU. Este módulo realiza múltiples pruebas automatizadas para cada operación soportada por la ALU, asegurando que los resultados sean correctos.

##### Parámetros
- `NB_DATA`: Número de bits para los datos (por defecto 8).
- `NB_OP`: Número de bits para el código de operación (por defecto 6).
- `N_TEST`: Número de pruebas a realizar para cada operación (por defecto 4).

##### Entradas
- `i_dataA`: Primer operando (entrada de datos).
- `i_dataB`: Segundo operando (entrada de datos).
- `i_op`: Código de operación a ejecutar.

##### Salidas
- `o_result`: Resultado de la operación realizada por la ALU.
- `o_overflow`: Señal que indica si se produjo un desbordamiento.

### 5-Módulo de Prueba TOP_TB

El módulo `TOP_TB` es un banco de pruebas para el módulo `TOP`, que implementa una ALU parametrizable. Este módulo realiza pruebas automatizadas para asegurar que el comportamiento del diseño sea el esperado.

### Parámetros
- **NB_DATA**: Número de bits para los datos (por defecto 8).
- **NB_OP**: Número de bits para el código de operación (por defecto 6).
- **N_TEST**: Número de pruebas a realizar para cada operación (por defecto 3).

### Entradas
- **i_dataSw**: Valor de entrada de los switches.
- **i_opSw**: Código de operación seleccionada desde los switches.
- **i_btnA**: Botón para cargar el primer operando.
- **i_btnB**: Botón para cargar el segundo operando.
- **i_btnO**: Botón para cargar la operación.
- **i_clk**: Señal de reloj.
- **i_reset**: Señal de reset.

### Salidas
- **o_resultLed**: Resultado de la operación mostrada en LEDs.
- **o_overflowLed**: Señal de overflow mostrada en un LED.
  
## RTL Analisis
  A continuación, se muestra el diagrama RTL (Register Transfer Level) generado en Vivado, que representa el diseño de la ALU con registros de entrada y salida, así como el flujo de señales entre los bloques lógicos.
![Schematic](/img/schematic.jpg "Schematic")

## Simulacion
En la simulación del diseño digital que se presenta, se ha llevado a cabo un análisis exhaustivo de las señales involucradas con el objetivo de verificar el comportamiento esperado del circuito bajo prueba. A continuación, se muestra una imagen generada por el software Vivado, correspondiente a la salida del módulo TOP del diseño. Este módulo representa la jerarquía más alta en el circuito, integrando diversos componentes que trabajan conjuntamente para ejecutar las operaciones requeridas.
![Simulation](/img/simulation.jpg "Simulation")

## Interfaz de la placa BASYS 3
![Fpga](/img/fpga.jpg "Fpga")
