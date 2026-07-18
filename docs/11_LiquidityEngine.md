
# Liquidity Engine

## Objetivo

El Liquidity Engine identifica las zonas donde existe una mayor probabilidad de que el precio se dirija antes de realizar un movimiento significativo.

Estas zonas se consideran objetivos potenciales ("metas") para el precio y sirven como contexto para buscar una entrada posterior.

El módulo **no abre operaciones**. Su única función es localizar y clasificar la liquidez.

---

# Responsabilidades

El módulo deberá ser capaz de detectar:

* Swing High Liquidity
* Swing Low Liquidity
* Equal Highs (EQH)
* Equal Lows (EQL)
* Daily High (PDH)
* Daily Low (PDL)
* Weekly High (PWH)
* Weekly Low (PWL)
* Liquidez Interna
* Liquidez Externa

Nunca deberá:

* Detectar CHOCH.
* Detectar FVG.
* Calcular el Score.
* Abrir operaciones.

---

# Filosofía

El mercado tiende a buscar zonas donde existen órdenes pendientes.

Estas zonas actuarán como objetivos probables antes de una reversión o continuación.

El objetivo del módulo es responder:

> ¿Dónde es más probable que vaya el precio?

No:

> ¿Debemos comprar o vender?

---

# Tipos de Liquidez

## 1. Swing High Liquidity

Corresponde al máximo de un Swing High confirmado.

Representa un lugar donde normalmente existen Stop Loss de vendedores y órdenes Buy Stop.

Si el precio rompe ese nivel, se considera que la liquidez superior ha sido tomada.

---

## 2. Swing Low Liquidity

Corresponde al mínimo de un Swing Low confirmado.

Representa Stop Loss de compradores y Sell Stops.

---

## 3. Equal High (EQH)

Dos o más Swing High consecutivos con una diferencia menor a una tolerancia configurable.

Ejemplo:

```text
High 1 = 3348.20

High 2 = 3348.24

Diferencia = 0.04
```

Si la diferencia es menor que:

```text
EqualHighTolerance
```

El sistema marcará una zona de Equal High.

---

## 4. Equal Low (EQL)

Misma lógica aplicada a mínimos.

---

# Daily High

Máximo del día anterior.

Configuración:

```text
UsePreviousDayHigh = true
```

---

# Daily Low

Mínimo del día anterior.

---

# Weekly High

Máximo de la semana anterior.

---

# Weekly Low

Mínimo de la semana anterior.

---

# Liquidez Externa

Se considera liquidez externa cuando el precio busca romper un máximo o mínimo importante.

Ejemplos:

* Weekly High
* Weekly Low
* Swing High mayor
* Swing Low mayor

---

# Liquidez Interna

Se considera liquidez interna aquella existente dentro del rango actual.

Ejemplos:

* Equal High
* Equal Low
* Swings intermedios

---

# Prioridad de Liquidez

Cuando existan varias zonas cercanas, el EA deberá asignar prioridades.

Orden recomendado:

1. Weekly High / Weekly Low
2. Daily High / Daily Low
3. Swing High / Swing Low
4. Equal High / Equal Low
5. Liquidez interna

---

# Distancia Mínima

No se marcarán dos zonas prácticamente iguales.

Si dos niveles están demasiado próximos:

Mantener únicamente el más relevante.

---

# Barrida de Liquidez (Liquidity Sweep)

Una barrida será válida únicamente si:

* El precio rompe una zona de liquidez.
* Existe desplazamiento suficiente.
* La vela cierra.
* El movimiento no corresponde únicamente a una mecha aislada (este valor podrá configurarse).

**Nota:** En futuras versiones podrá añadirse un parámetro para permitir barridas por mecha si el backtesting demuestra que mejoran los resultados.

---

# Zonas Premium y Discount

El módulo calculará el rango del último impulso válido.

A partir de ese rango:

50 %

↓

Premium

↓

Discount

Las ventas tendrán mayor probabilidad en Premium.

Las compras tendrán mayor probabilidad en Discount.

Este filtro será opcional.

---

# Información entregada

El módulo deberá devolver:

* Tipo de liquidez.
* Precio.
* Fecha.
* Timeframe.
* Prioridad.
* Estado.

---

# Estado

Cada zona podrá encontrarse en uno de los siguientes estados:

* Activa
* Barrida
* Invalidada

---

# Timeframes

El análisis se realizará utilizando:

* H4
* H1
* M30
* M15

Los timeframes inferiores consumirán esta información.

---

# Configuración

Todos los parámetros deberán declararse en:

Core/Config.mqh

Variables sugeridas:

```text
EqualHighTolerance

EqualLowTolerance

MinimumLiquidityDistance

UseDailyHighLow

UseWeeklyHighLow

UseEqualHighLow

UseSwingLiquidity

UsePremiumDiscount
```

---

# Filtros

No considerar:

* Swings sin confirmar.
* Equal High con diferencia superior a la tolerancia.
* Máximos creados durante mercados laterales extremadamente estrechos.
* Niveles demasiado cercanos entre sí.

---

# Casos Especiales

## Noticias

Durante noticias puede romperse más de una zona en pocos segundos.

Registrar todas las barridas, pero dejar que el módulo CHOCH determine si existe una confirmación válida.

---

## Múltiples zonas

Si varias zonas coinciden en un mismo rango (por ejemplo, Weekly High y Equal High), aumentar su prioridad.

---

# Funciones sugeridas

```text
DetectSwingLiquidity()

DetectEqualHigh()

DetectEqualLow()

DetectDailyHigh()

DetectDailyLow()

DetectWeeklyHigh()

DetectWeeklyLow()

DetectPremiumDiscount()

DetectLiquiditySweep()

GetNearestLiquidity()

GetHighestPriorityLiquidity()

UpdateLiquidity()
```

---

# Salida para otros módulos

El Liquidity Engine proporcionará:

* Lista de zonas activas.
* Próxima meta de liquidez.
* Tipo de liquidez.
* Dirección esperada.
* Estado de cada zona.

Estos datos serán utilizados posteriormente por:

* CHOCHEngine
* EntryManager
* ConfirmationScore

---

# Notas para GitHub Copilot

Este módulo únicamente detecta y clasifica liquidez.

No interpreta tendencias.

No busca confirmaciones.

No abre operaciones.

Debe ser reutilizable para cualquier estrategia basada en Smart Money Concepts.
