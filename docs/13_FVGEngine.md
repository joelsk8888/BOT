# 13_FVGEngine.md

# Fair Value Gap Engine

## Objetivo

El FVG Engine detecta desequilibrios del mercado (Fair Value Gaps) generados por movimientos impulsivos.

Estos desequilibrios representan zonas donde el precio puede regresar antes de continuar con el movimiento esperado.

El módulo nunca abrirá operaciones.

Su única responsabilidad será detectar, clasificar y gestionar Fair Value Gaps.

---

# Filosofía

Un Fair Value Gap representa una ineficiencia del mercado.

Normalmente aparece después de un desplazamiento fuerte.

No todos los FVG son válidos.

Solo tendrán importancia aquellos alineados con:

* Tendencia.
* Liquidez.
* CHOCH.
* Displacement.

---

# Definición

Se utilizará la definición clásica de tres velas.

Bullish FVG

```text
Vela 1

██████

Vela 2

██████████████

Vela 3

      ██████
```

Existe un hueco entre:

High de la vela 1

y

Low de la vela 3

---

Bearish FVG

```text
      ██████

██████████████

██████
```

Existe un hueco entre:

Low de la vela 1

y

High de la vela 3

---

# Requisitos

Para considerar válido un FVG.

Debe existir previamente.

* Liquidez.
* CHOCH.
* Displacement.

Si alguno falta.

El FVG pierde prioridad.

---

# Tamaño mínimo

No todos los FVG son importantes.

El hueco deberá superar un tamaño mínimo configurable.

Variables.

MinimumFVGSize

---

# Clasificación

Cada FVG recibirá una clasificación.

Alta

Media

Baja

La calidad dependerá de.

* Tamaño.
* Desplazamiento.
* Tendencia.
* Cercanía a liquidez.

---

# Mitigación

Un FVG podrá encontrarse.

Activa.

Mitigada parcialmente.

Mitigada completamente.

Invalidada.

---

# Mitigación Parcial

El precio entra únicamente en una parte del FVG.

El FVG continúa siendo válido.

---

# Mitigación Completa

El precio llena completamente el FVG.

Podrá eliminarse.

---

# Invalidación

Un FVG será inválido cuando.

* La estructura cambie completamente.
* Se produzca un CHOCH contrario.
* Sea atravesado completamente varias veces.
* Supere la antigüedad máxima configurada.

---

# Prioridad

Cuando existan varios FVG.

Ordenar por.

1.

Alineación con H4.

2.

Alineación con H1.

3.

Mayor desplazamiento.

4.

Mayor tamaño.

5.

Mayor cercanía a liquidez.

---

# Timeframes

Buscar únicamente en.

M1

M5

Opcionalmente.

M15

---

# Relación con CHOCH

Un CHOCH acompañado por un FVG tendrá mayor puntuación.

Si no existe FVG.

La operación aún podrá ejecutarse.

Pero con menor Score.

---

# Relación con Liquidez

Los mejores FVG serán aquellos creados inmediatamente después de una barrida de liquidez.

---

# Relación con la Tendencia

Priorizar.

FVG alcistas.

Cuando H4 y H1 sean alcistas.

FVG bajistas.

Cuando H4 y H1 sean bajistas.

---

# Configuración

Todas las variables deberán declararse en Config.mqh.

Variables sugeridas.

UseFVG

MinimumFVGSize

MaximumFVGAge

RequireMitigation

UsePartialMitigation

---

# Funciones sugeridas

DetectBullishFVG()

DetectBearishFVG()

ValidateFVG()

UpdateFVG()

RemoveInvalidFVG()

FindNearestFVG()

CalculateFVGQuality()

IsMitigated()

---

# Información entregada

El módulo devolverá.

Tipo.

Dirección.

Precio superior.

Precio inferior.

Tamaño.

Estado.

Edad.

Calidad.

Mitigación.

---

# Casos Especiales

## Noticias

Durante noticias.

Podrán aparecer múltiples FVG consecutivos.

Conservar únicamente los más relevantes.

---

## Solapamiento

Si dos FVG se superponen.

Fusionarlos en una única zona.

---

## Mercado lateral

Ignorar FVG creados dentro de rangos extremadamente estrechos.

---

# Salida para otros módulos

ConfirmationScore utilizará.

Calidad.

Tamaño.

Mitigación.

EntryManager utilizará.

Precio.

Dirección.

Zona.

Logger registrará.

Tamaño.

Estado.

Resultado.

---

# Notas para GitHub Copilot

Este módulo únicamente detecta Fair Value Gaps.

Nunca deberá.

Abrir operaciones.

Gestionar posiciones.

Detectar tendencia.

Detectar CHOCH.

Toda la lógica relacionada con la entrada permanecerá fuera de este módulo.

El código deberá ser reutilizable para cualquier estrategia basada en Smart Money Concepts.
