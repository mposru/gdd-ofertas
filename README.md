# Sistema de Ofertas

#### Trabajo Práctico Grupal realizado para la materia _Gestión de Datos_ en la UTN FRBA - 2do cuatrimestre 2019

Mediante este trabajo práctico se intenta simular la migración y remoción de un viejo sistema de ofertas que ha quedado obsoleto.
Es para ello que se necesita que se reformulen los procesos y el diseño de la base de datos que cumpla con las nuevas restricciones y se adecue a la situación actual.

Componentes del sistema:
* _Migración y Normalización Base de Datos:_ Al ejecutar el script: [script_creacion_inicial.sql](/data/script_creacion_inicial.sql), se migra la base de datos vieja a una nueva base de datos normalizada, según el siguiente DER:
![](/DER.png)

* _Aplicación Sistema de Ofertas:_ Este componente se trata de una aplicación Desktop que interactúa con la nueva base de datos. Está realizada en C#, con Visual Studio 2012 y Framework .NET 4.5

Más información en el [enunciado del trabajo práctico](/Enunciado.pdf) y la [estrategia de resolución](/Estrategia.pdf)
