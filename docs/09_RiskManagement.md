# Gestión del Riesgo - SmartMoneyEA

## Objetivo

La gestión del riesgo será completamente independiente del sistema de entrada.

El propósito del módulo no será únicamente limitar pérdidas, sino proteger el capital, preservar la ventaja estadística de la estrategia y maximizar el beneficio cuando el mercado confirme el análisis.

La filosofía principal del proyecto es que **el riesgo debe gestionarse mediante la estructura del mercado**, no mediante distancias fijas.

---

# Principios

El EA nunca deberá:

- Operar por impulso.
- Aumentar el lote después de una pérdida.
- Utilizar Martingala.
- Promediar pérdidas.
- Abrir varias operaciones simultáneas sobre XAUUSD.

La prioridad siempre será la supervivencia del capital.

---

# Operaciones simultáneas

Versión 1.0

Máximo:

- 1 operación abierta sobre XAUUSD.

Mientras exista una operación activa:

- No se evaluarán nuevas entradas.

---

# Riesgo por operación

El riesgo será configurable.

Valor recomendado:

0.50 % - 1.00 %

Nunca superior al 2 %.

Inicialmente el sistema utilizará riesgo fijo.

En futuras versiones podrá utilizar riesgo dinámico basado en la calidad de la operación.

---

# Riesgo diario

Parámetro:

MaxDailyRisk

Valor recomendado:

2 %

Si durante el día se alcanza este límite:

- No abrir nuevas operaciones.
- Esperar al siguiente día de trading.

---

# Drawdown máximo

Parámetro:

MaxAccountDrawdown

Valor recomendado:

10 %

Al superar dicho valor:

- El EA dejará de operar automáticamente.

---

# Invalidación estructural

La estrategia no considera que una operación esté equivocada únicamente porque el precio se mueva en contra.

Una operación será inválida únicamente cuando desaparezca la estructura que justificó la entrada.

Ejemplos:

Compra:

- Se barre liquidez inferior.
- Aparece CHOCH alcista.
- Existe displacement.
- Se genera un FVG.
- Se ejecuta la compra.

La operación será inválida si posteriormente el mercado rompe nuevamente el mínimo que originó la barrida.

Venta:

- Se barre liquidez superior.
- Aparece CHOCH bajista.
- Existe displacement.
- Se genera un FVG.
- Se ejecuta la venta.

La operación será inválida si posteriormente el mercado rompe nuevamente el máximo que originó la barrida.

Estas reglas podrán modificarse mediante parámetros.

---

# Stop Loss

El sistema ofrecerá tres modos.

## Modo 1 - Stop estructural (Recomendado)

El Stop Loss se colocará detrás del swing que invalida el análisis.

Nunca utilizar una distancia fija.

---

## Modo 2 - Sin Stop Loss inicial

No se colocará Stop Loss al abrir la operación.

El EA supervisará continuamente la estructura.

Cuando la estructura quede invalidada:

- Cerrar inmediatamente la operación.

Este modo reproduce la forma de operar manual del usuario, pero presenta un riesgo significativamente mayor frente a movimientos extremos, gaps o eventos de alta volatilidad.

---

## Modo 3 - Stop dinámico

La operación comienza sin Stop Loss.

Cuando el precio confirme el movimiento mediante nuevos swings:

- El EA colocará automáticamente un Stop estructural.

Este modo busca combinar flexibilidad inicial con protección progresiva.

---

# Break Even Inteligente

No mover el Stop únicamente porque la operación ganó cierta cantidad de puntos.

Mover el Stop únicamente cuando:

- Se genere una nueva estructura favorable.
- El mercado confirme un nuevo HL o LH.
- Exista suficiente espacio para evitar ser expulsado por el ruido.

---

# Trailing Stop

No utilizar trailing basado en puntos.

Utilizar únicamente trailing estructural.

El Stop seguirá:

Compras

HL → HL → HL

Ventas

LH → LH → LH

Siempre respetando la estructura del mercado.

---

# Take Profit

El sistema ofrecerá varios modos.

## TP Fijo

Objetivo definido por el usuario.

---

## TP por Liquidez (Recomendado)

El objetivo será la siguiente zona importante de liquidez.

Ejemplos:

- Equal High
- Equal Low
- Daily High
- Daily Low
- Weekly High
- Weekly Low

---

## TP Parcial

Ejemplo:

Primer objetivo:

Cerrar 50 % de la posición.

Segundo objetivo:

Buscar la siguiente zona de liquidez.

Los porcentajes serán configurables.

---

## Salida por Cambio Estructural

Opcional.

Si aparece un CHOCH contrario antes del Take Profit:

- Cerrar parcial.
- Cerrar completamente.
- Ignorar.

El comportamiento será configurable.

---

# Gestión Inteligente

En versiones futuras el EA podrá aumentar o reducir el riesgo según un Quality Score calculado a partir de:

- Tendencia H4.
- Tendencia H1.
- Calidad de la liquidez.
- Calidad del CHOCH.
- Displacement.
- Calidad del FVG.
- Mitigación.
- Envolvente.

Esta funcionalidad permanecerá deshabilitada en la versión inicial hasta ser validada mediante backtesting.

---

# Protección

El EA deberá impedir:

- Martingala.
- Grid.
- Averaging Down.
- Sobreapalancamiento.
- Operar después de alcanzar el riesgo diario.
- Operar durante un bloqueo por drawdown.

---

# Registro

El módulo de gestión almacenará información detallada de cada operación.

Entre otros datos:

- Riesgo utilizado.
- Tipo de Stop Loss.
- Distancia del Stop.
- Tipo de Take Profit.
- Parciales ejecutados.
- Break Even.
- Trailing.
- Tiempo en mercado.
- Máximo beneficio flotante.
- Máxima pérdida flotante.
- Motivo exacto del cierre.

---

# Filosofía del módulo

El objetivo del SmartMoneyEA no será ganar todas las operaciones.

El objetivo será proteger el capital mientras permite que las operaciones de mayor calidad desarrollen todo su potencial.

Una buena gestión del riesgo deberá convertir una ventaja estadística pequeña en un sistema rentable a largo plazo.