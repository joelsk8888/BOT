# Parámetros del SmartMoneyEA

## Objetivo

Todos los parámetros configurables del EA deberán definirse aquí.

El objetivo es permitir realizar backtesting y optimización sin modificar el código fuente.

---

# 1. Mercado

Symbol = XAUUSD

---

# 2. Estructura

## PivotStrength

Define la fuerza mínima requerida para confirmar un swing.

Valor recomendado inicial:

PivotStrength = 5

Rango para pruebas:

3 - 10

---

## MinSwingDistance

Distancia mínima entre swings.

Evita detectar ruido.

Valor inicial:

Auto (ATR)

---

# 3. Tendencia

## UseH4Bias

Determina si se utiliza H4 para filtrar operaciones.

Default:

true

---

## UseH1Confirmation

Determina si H1 debe confirmar H4.

Default:

true

---

# 4. Liquidez

## UseWeeklyLiquidity

Default:

true

---

## UseDailyLiquidity

Default:

true

---

## UseEqualHighs

Default:

true

---

## UseEqualLows

Default:

true

---

## EqualHighTolerance

Distancia máxima para considerar dos máximos iguales.

Inicial:

0.20 ATR

---

## EqualLowTolerance

Inicial:

0.20 ATR

---

# 5. CHOCH

## UseCHOCH

Default:

true

---

## CHOCHCloseRequired

Exigir cierre para validar CHOCH.

Default:

true

---

## CHOCHTimeframe

Default:

M1

---

# 6. Displacement

## UseDisplacement

Default:

true

---

## MinDisplacementATR

Mínimo desplazamiento requerido.

Inicial:

1.5 ATR

---

# 7. Fair Value Gap

## UseFVG

Default:

true

---

## WaitForMitigation

Default:

true

---

## MinFVGSize

Tamaño mínimo del FVG.

Inicial:

0.30 ATR

---

## MaxFVGDistance

Distancia máxima entre CHOCH y FVG.

Inicial:

2 ATR

---

# 8. Envolvente

## UseEngulfing

Default:

true

---

## EngulfingTimeframe

Default:

M5

---

## RequireBodyEngulf

Default:

true

---

# 9. Entrada

## EntryMode

Valores:

Market
Limit

Inicial:

Market

---

# 10. Take Profit

## TPMode

Valores:

Fixed
NextLiquidity
Partial

Inicial:

NextLiquidity

---

## FixedTP

Valor inicial:

300 puntos

---

# 11. Gestión

## UseBreakEven

Default:

true

---

## BreakEvenTrigger

Inicial:

1R

---

## UseTrailingStructure

Default:

true

---

## UsePartials

Default:

true

---

# 12. Riesgo

## MaxDailyRisk

Inicial:

2%

---

## MaxTotalDrawdown

Inicial:

10%

---

## MaxTradesPerDay

Inicial:

3

---

# 13. Horarios

## SessionMode

Valores:

AllDay
London
NewYork
LondonNewYork

Inicial:

AllDay

---

# 14. Registro

## EnableTradeLogger

Default:

true

---

## EnableResearchMode

Default:

true

---

## SaveCSV

Default:

true

---

# 15. Sistema de Puntuación

## MinimumScore

Puntuación mínima para operar.

Inicial:

80

---

## ScoreH4Trend

20

## ScoreH1Trend

15

## ScoreLiquidity

25

## ScoreCHOCH

20

## ScoreDisplacement

10

## ScoreFVG

10

## ScoreMitigation

5

## ScoreEngulfing

5