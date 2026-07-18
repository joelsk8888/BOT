
# CHOCH Engine

## Objetivo

El CHOCH Engine valida que, después de una barrida de liquidez, exista un cambio real en la estructura del mercado.

El módulo será el encargado de determinar si el movimiento observado representa una posible reversión o simplemente una continuación de la tendencia.

Nunca abrirá operaciones.

Su única responsabilidad será confirmar el cambio estructural.

---

# Filosofía

Una barrida de liquidez, por sí sola, no justifica una entrada.

El CHOCH representa la primera evidencia de que el control del mercado podría haber cambiado de manos.

---

# Flujo General

```
Liquidez

↓

Barrida

↓

CHOCH

↓

Displacement

↓

FVG

↓

Mitigación (Opcional)

↓

Envolvente

↓

Score
```

---

# Timeframes

## CHOCH

M1

---

## Confirmación adicional

M5

---

# Requisitos

Antes de buscar un CHOCH deben cumplirse todas las condiciones siguientes.

* Existe tendencia definida.
* Existe una zona de liquidez.
* La liquidez fue barrida.
* No existe una operación abierta.

Si alguna condición falla:

No continuar.

---

# Definición de CHOCH

Un CHOCH ocurre cuando el precio rompe la estructura más reciente en sentido contrario al movimiento anterior.

No basta con una mecha.

Debe existir un cierre válido.

---

# CHOCH Alcista

Secuencia.

```
LL

↓

LH

↓

Ruptura del último LH

↓

CHOCH Alcista
```

---

# CHOCH Bajista

```
HH

↓

HL

↓

Ruptura del último HL

↓

CHOCH Bajista
```

---

# Confirmación

El cierre deberá superar claramente el nivel estructural.

No aceptar rupturas únicamente por mecha.

---

# Displacement

Después del CHOCH debe existir un movimiento impulsivo.

Características.

* Velas grandes.
* Poco retroceso.
* Cuerpo dominante.
* Cierre cercano al extremo.

El objetivo es demostrar intención institucional.

---

# Parámetros

```text
MinimumDisplacementSize

MinimumBodyPercent

MinimumCloseStrength
```

Todos configurables.

---

# Fair Value Gap

Después del desplazamiento deberá buscarse un FVG.

Si existe:

Añadir puntos al Score.

Si no existe:

La operación podrá seguir siendo válida.

---

# Mitigación

Configurable.

Si está activada.

Esperar que el precio regrese parcialmente al FVG.

Después continuar.

---

# Envolvente

La confirmación final será una vela envolvente en M5.

Características.

* Cuerpo mayor que la vela anterior.
* Envuelve completamente el cuerpo previo.
* Cierre fuerte.

No utilizar únicamente mechas.

---

# Score

Cada confirmación incrementará la calidad de la oportunidad.

Ejemplo.

Liquidez

20

CHOCH

20

Displacement

20

FVG

15

Mitigación

10

Envolvente

15

Total

100

---

# Entradas Rechazadas

No abrir operación cuando.

* No exista liquidez.
* No exista CHOCH.
* El desplazamiento sea débil.
* El mercado permanezca lateral.
* El Score sea inferior al mínimo configurado.
* Se haya alcanzado el riesgo diario.
* El spread supere el límite permitido.

---

# Casos Especiales

## Doble Barrida

Si el precio realiza varias barridas consecutivas.

Esperar únicamente la primera confirmación válida.

---

## Noticias

Si la barrida ocurre durante una noticia de alto impacto.

El filtro de noticias decidirá si se permite continuar.

---

## CHOCH Repetido

No generar múltiples señales sobre la misma estructura.

Cada CHOCH únicamente podrá generar una oportunidad.

---

# Funciones sugeridas

```text
DetectCHOCH()

ValidateCHOCH()

DetectDisplacement()

ValidateDisplacement()

FindConfirmation()

CalculateConfirmationStrength()

GetCHOCHDirection()

UpdateCHOCH()
```

---

# Salida

El módulo devolverá.

* Dirección.
* Estado.
* Intensidad.
* Precio.
* Hora.
* Confirmaciones encontradas.
* Score parcial.

---

# Información para otros módulos

EntryManager utilizará.

* Dirección.
* Confirmación.

ConfirmationScore utilizará.

* Intensidad.
* Calidad.
* Confirmaciones.

Logger almacenará.

* Hora.
* Precio.
* Tipo.
* Confirmaciones.

---

# Notas para GitHub Copilot

Este módulo nunca deberá abrir operaciones.

Nunca deberá modificar posiciones.

Su única responsabilidad consiste en confirmar si realmente existe un cambio estructural válido después de una barrida de liquidez.

Todas las decisiones posteriores serán tomadas por EntryManager y TradeManager.
