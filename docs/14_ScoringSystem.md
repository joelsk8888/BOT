# Sistema de Puntuación - SmartMoneyEA

## Objetivo

El Scoring System tiene como finalidad evaluar la calidad de cada oportunidad de trading antes de permitir una entrada.

En lugar de operar únicamente porque existe un CHOCH o una barrida de liquidez, el EA calculará una puntuación basada en múltiples factores.

Solo se abrirán operaciones cuya puntuación supere un umbral mínimo configurable.

---

# Filosofía

No todas las señales tienen la misma calidad.

El objetivo es filtrar operaciones de baja probabilidad y priorizar aquellas donde existe una mayor confluencia.

---

# Factores Evaluados

## Tendencia H4

Mercado alineado con la dirección de la operación.

Puntos:

20

---

## Tendencia H1

Confirma la dirección definida por H4.

Puntos:

15

---

## Barrida de Liquidez

Debe existir una barrida válida.

Puntos:

20

---

## CHOCH

Debe existir un cambio de estructura válido.

Puntos:

15

---

## Displacement

Movimiento impulsivo posterior al CHOCH.

Puntos:

10

---

## Fair Value Gap

Debe existir un FVG válido.

Puntos:

10

---

## Mitigación

Si el precio mitiga correctamente el FVG.

Puntos:

5

---

## Vela Envolvente

Confirmación mediante envolvente en M5.

Puntos:

5

---

# Score Máximo

100 puntos

---

# Clasificación

95 - 100

Excelente

---

85 - 94

Muy Alta

---

75 - 84

Alta

---

65 - 74

Media

---

Menor de 65

Descartar operación

---

# Configuración

MinimumScore

Valor recomendado:

80

---

# Futuras versiones

El Score podrá utilizarse para modificar el riesgo por operación.

Versión 1.0

El Score únicamente decidirá si se opera o no.