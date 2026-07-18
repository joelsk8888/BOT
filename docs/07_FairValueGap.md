# Fair Value Gap (FVG)

## Objetivo

El módulo Fair Value Gap tendrá como función detectar desequilibrios del mercado producidos por desplazamientos fuertes del precio.

El EA utilizará estos desequilibrios como una confirmación adicional de intención institucional.

---

## Funciones del módulo

- Detectar Fair Value Gaps alcistas.
- Detectar Fair Value Gaps bajistas.
- Dibujar automáticamente los FVG.
- Calcular el tamaño del FVG.
- Detectar si fue mitigado.
- Medir la calidad del FVG.
- Registrar toda la información para análisis estadísticos.

---

## Parámetros configurables

- Activar/desactivar FVG.
- Esperar mitigación.
- Tamaño mínimo del FVG.
- Distancia máxima entre CHOCH y FVG.
- Tiempo máximo de validez del FVG.

---

## Registro

Cada FVG almacenará:

- Tipo.
- Temporalidad.
- Hora de creación.
- Tamaño.
- Distancia respecto al CHOCH.
- Estado (Mitigado / No mitigado).
- Resultado de la operación.

---

## Objetivo

Determinar mediante backtesting si el uso de Fair Value Gaps mejora la tasa de aciertos, el Profit Factor y la expectativa matemática de la estrategia.