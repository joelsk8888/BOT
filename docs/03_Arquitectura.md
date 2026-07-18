# Arquitectura del SmartMoneyEA

## Objetivo

Definir la arquitectura oficial del Expert Advisor.

Este documento describe la organización interna del proyecto, la responsabilidad de cada módulo y la comunicación entre ellos.

El objetivo principal es garantizar un sistema modular, mantenible, escalable y fácilmente comprensible tanto para desarrolladores como para agentes de IA (GitHub Copilot, Claude Code, Codex, etc.).

---

# Filosofía del Proyecto

El SmartMoneyEA NO es simplemente un Expert Advisor.

Es un framework modular para estrategias basadas en Smart Money Concepts.

Cada componente deberá cumplir una única responsabilidad.

La modificación o sustitución de un módulo no deberá afectar al resto del sistema.

---

# Arquitectura General

```
                  +----------------------+
                  |      OnTick()        |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Actualizar Mercado   |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |   SwingDetector      |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | MarketStructure      |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Trend Analyzer       |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Liquidity Engine      |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | CHOCH Detector       |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | FVG Detector         |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Confirmation Score   |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Entry Manager        |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Trade Manager        |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Risk Manager         |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Logger               |
                  +----------------------+
```

---

# Flujo del EA

Cada tick seguirá exactamente el siguiente proceso.

## Paso 1

Actualizar información del mercado.

- Precio Bid
- Precio Ask
- Spread
- Hora
- Nueva vela

---

## Paso 2

Actualizar Swings.

Responsable:

SwingDetector.mqh

Salida esperada:

- Swing High
- Swing Low

---

## Paso 3

Actualizar estructura.

Responsable:

MarketStructure.mqh

Salida:

- HH
- HL
- LH
- LL

---

## Paso 4

Calcular tendencia.

Responsable:

Trend.mqh

Timeframes:

- H4
- H1

Salida:

Bullish

Bearish

Range

---

## Paso 5

Buscar liquidez.

Responsable:

Liquidity.mqh

Detectar:

- Equal High
- Equal Low
- Daily High
- Daily Low
- Weekly High
- Weekly Low
- Swing Liquidity

---

## Paso 6

Esperar barrida.

Si no existe barrida:

No continuar.

---

## Paso 7

Buscar CHOCH.

Responsable:

CHOCH.mqh

Si no existe:

Esperar.

---

## Paso 8

Buscar Displacement.

Debe existir un movimiento impulsivo.

---

## Paso 9

Buscar Fair Value Gap.

Responsable:

FairValueGap.mqh

---

## Paso 10

Esperar mitigación (si está activada).

---

## Paso 11

Buscar envolvente.

Responsable:

Engulfing.mqh

Timeframe:

M5

---

## Paso 12

Calcular Score.

Responsable:

ConfirmationScore.mqh

---

## Paso 13

Validar filtros.

- Sesión
- Spread
- Noticias
- Riesgo diario

---

## Paso 14

Abrir operación.

Responsable:

EntryManager.mqh

---

## Paso 15

Gestionar operación.

Responsable:

TradeManager.mqh

Funciones:

- TP
- BreakEven
- Parciales
- Trailing

---

## Paso 16

Registrar información.

Responsable:

Logger.mqh

---

# Responsabilidades

## SwingDetector

Únicamente detecta pivotes.

No interpreta tendencia.

No detecta liquidez.

No abre operaciones.

---

## MarketStructure

Convierte los pivotes en:

- HH
- HL
- LH
- LL

---

## Trend

Determina:

- Bullish
- Bearish
- Range

---

## Liquidity

Encuentra zonas objetivo.

Nunca genera entradas.

---

## CHOCH

Detecta cambios de estructura.

Nunca ejecuta operaciones.

---

## FairValueGap

Detecta desequilibrios.

No interpreta tendencia.

---

## Confirmation Score

Calcula la calidad de la oportunidad.

No compra.

No vende.

---

## Entry Manager

Únicamente abre operaciones.

Nunca analiza el mercado.

---

## Trade Manager

Gestiona operaciones abiertas.

Nunca busca nuevas entradas.

---

## Logger

Registra todas las decisiones.

Nunca modifica operaciones.

---

# Dependencias

Cada módulo deberá depender únicamente de la información estrictamente necesaria.

Ejemplo.

Trend depende de:

MarketStructure.

Pero Trend nunca deberá depender de TradeManager.

---

# Configuración

Toda variable configurable deberá declararse únicamente en:

Core/Config.mqh

Queda prohibido utilizar valores fijos distribuidos por distintos módulos.

---

# Estándares

Cada clase deberá cumplir una única responsabilidad.

Cada función deberá tener un propósito claro.

Los nombres deberán ser descriptivos.

Evitar funciones excesivamente largas.

No utilizar números mágicos.

No duplicar lógica.

---

# Escalabilidad

La arquitectura deberá permitir añadir en el futuro:

- Order Blocks
- SMT Divergence
- Liquidity Voids
- Kill Zones
- Multi Symbol
- Machine Learning
- Riesgo dinámico
- Optimización genética

sin modificar la estructura principal del proyecto.

---

# Objetivo Final

El SmartMoneyEA deberá convertirse en un framework reutilizable para estrategias Smart Money.

La arquitectura deberá facilitar la investigación, el backtesting y la evolución del sistema durante los próximos años sin necesidad de reescribir el núcleo del proyecto.