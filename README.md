# Exchange La Banana

## Inicio rápido
 
La entrada de ordenes se debe ingresar con un archivo json válido al método :load_initial_orders de una instancia de la clase Market. Por defecto usará 'input.json'.

Correr el archivo init.rb para generar el archivo output.json

Ejecutar las pruebas con rspec spec

## Detalles

El programa consta de tres clases principales:

  - Market: Encargada de recibir y buscar los candidatos para emparejar las ordenes
  - Transaction: Encargada de calcular los remanentes y actualizar los estados de las ordenes
  - Orden: Contiene el detalle de cada orden

 
