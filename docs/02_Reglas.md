# Reglas del SmartMoneyEA

## Objetivo

Definir todas las reglas que utilizará el Expert Advisor para decidir si abrir o no una operación.

El EA nunca tomará decisiones subjetivas.

Cada regla deberá poder convertirse directamente en código MQL5.

---

# ETAPA 1 - Análisis del Contexto

## Regla 1

Analizar la estructura del mercado en:

- H4
- H1

El objetivo NO es abrir operaciones.

El objetivo es determinar la dirección más probable del mercado.

Estados posibles:

- Bullish
- Bearish
- Range

---

## Regla 2

El H4 tendrá mayor prioridad que H1.

Ejemplo:

H4 = Bullish

H1 = Bullish

Bias = Compra

---

H4 = Bearish

H1 = Bearish

Bias = Venta

---

Si H4 y H1 están en conflicto:

No operar.

---

# ETAPA 2 - Liquidez

El EA buscará automáticamente:

- Weekly High
- Weekly Low
- Daily High
- Daily Low
- Equal Highs
- Equal Lows
- Swing Highs
- Swing Lows

Estas zonas serán consideradas objetivos del precio.

---

## Regla

No se abrirán operaciones mientras el precio no llegue a una zona de liquidez.

---

# ETAPA 3 - Barrida

Una barrida será válida cuando:

1. El precio rompa una zona de liquidez.

2. El movimiento sea rechazado.

3. El precio vuelva al rango anterior.

Solo entonces se buscarán confirmaciones.

---

# ETAPA 4 - CHOCH

Después de la barrida se analizará M1.

El CHOCH será válido únicamente cuando exista un cambio real de estructura.

El CHOCH será obligatorio.

---

# ETAPA 5 - Displacement

Después del CHOCH deberá existir un movimiento impulsivo.

Este movimiento deberá demostrar intención.

Sin desplazamiento no habrá entrada.

---

# ETAPA 6 - Fair Value Gap

El desplazamiento deberá generar un Fair Value Gap.

Dependiendo de la configuración del EA:

Modo A

Entrar inmediatamente.

Modo B

Esperar mitigación del FVG.

---

# ETAPA 7 - Envolvente

Después del FVG se buscará una vela envolvente en M5.

La envolvente será una confirmación adicional.

Podrá activarse o desactivarse desde la configuración.

---

# ETAPA 8 - Entrada

La entrada únicamente podrá ejecutarse cuando:

✔ Contexto válido

✔ Liquidez

✔ Barrida

✔ CHOCH

✔ Displacement

✔ FVG

✔ Envolvente (si está activada)

---

# ETAPA 9 - Gestión

Solo podrá existir una operación abierta sobre XAUUSD.

La gestión podrá realizarse mediante:

- TP fijo

- TP por siguiente liquidez

- Parciales

- Trailing estructural

- Break Even

---

# ETAPA 10 - Registro

Cada operación almacenará:

- Fecha

- Hora

- Tipo

- Bias H4

- Bias H1

- Liquidez utilizada

- CHOCH

- Displacement

- FVG

- Mitigación

- Envolvente

- TP

- Resultado

- Duración

- Beneficio

- Motivo de salida