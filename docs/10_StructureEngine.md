
# Structure Engine

## Objetivo

El Structure Engine es el núcleo del SmartMoneyEA.

Su responsabilidad es interpretar la estructura del mercado de manera objetiva, sin utilizar indicadores externos.

Todo el sistema depende de este módulo. Si la estructura es incorrecta, la detección de liquidez, CHOCH, FVG y las entradas también serán incorrectas.

---

# Responsabilidad

Este módulo deberá ser capaz de:

* Detectar Swing High.
* Detectar Swing Low.
* Construir la estructura del mercado.
* Clasificar HH, HL, LH y LL.
* Detectar BOS (Break of Structure).
* Detectar cambios de tendencia.
* Proporcionar información estructural al resto de módulos.

Este módulo **nunca** deberá:

* Abrir operaciones.
* Detectar Fair Value Gaps.
* Detectar Order Blocks.
* Detectar CHOCH.
* Gestionar riesgo.
* Dibujar información no relacionada con la estructura.

---

# Timeframes utilizados

## Tendencia principal

H4

---

## Confirmación de tendencia

H1

---

## Refinamiento

M30

M15

---

## Timeframes inferiores

M5 y M1 únicamente consumirán la estructura generada por este módulo.

Nunca deberán generar una estructura independiente.

---

# Filosofía

La estructura del mercado representa la secuencia lógica de máximos y mínimos.

El algoritmo deberá ignorar el ruido y detectar únicamente pivotes relevantes.

La estructura siempre tendrá prioridad sobre cualquier patrón de velas.

---

# Definiciones

## Swing High

Un Swing High es un máximo local confirmado.

Debe ser mayor que un número configurable de velas a su izquierda y derecha.

Ejemplo:

```
      ▲
     ███
   ███████
 ███████████
```

El máximo central es superior a todos los máximos vecinos.

---

## Swing Low

Un Swing Low es un mínimo local confirmado.

Debe ser menor que un número configurable de velas anteriores y posteriores.

Ejemplo

```
███████████
 █████████
  ███████
    ███
     ▼
```

---

# Pivot Strength

El parámetro PivotStrength controla la sensibilidad del detector.

Ejemplo:

PivotStrength = 3

Significa:

Para confirmar un Swing High, el High deberá ser mayor que los High de las tres velas anteriores y de las tres posteriores.

Mientras mayor sea este parámetro:

* Menor cantidad de swings.
* Mayor calidad estructural.
* Menor ruido.

Mientras menor sea:

* Mayor sensibilidad.
* Más señales.
* Mayor probabilidad de falsos pivotes.

---

# Recomendación

Para XAUUSD:

PivotStrength = 3

Posteriormente este valor podrá optimizarse.

---

# Confirmación del Swing

Un pivote nunca podrá confirmarse inmediatamente.

Siempre deberá esperar las velas necesarias definidas por PivotStrength.

Esto evita repintados.

---

# Estructura del Mercado

Una vez detectados los pivotes, el algoritmo construirá la secuencia estructural.

Los únicos estados posibles son:

* HH
* HL
* LH
* LL

No existen estados intermedios.

---

# Higher High (HH)

Se produce cuando un nuevo Swing High supera el último Swing High válido.

Representa fortaleza compradora.

---

# Higher Low (HL)

Se produce cuando un nuevo Swing Low permanece por encima del Swing Low anterior.

Representa continuidad alcista.

---

# Lower High (LH)

Se produce cuando un nuevo Swing High queda por debajo del anterior.

Representa debilidad compradora.

---

# Lower Low (LL)

Se produce cuando un nuevo Swing Low rompe el mínimo anterior.

Representa fortaleza vendedora.

---

# Tendencia Alcista

Una tendencia será alcista únicamente cuando exista una secuencia continua de:

HH → HL → HH → HL

Si la secuencia se rompe, la tendencia deberá reevaluarse.

---

# Tendencia Bajista

Una tendencia será bajista únicamente cuando exista una secuencia continua de:

LL → LH → LL → LH

---

# Mercado Lateral

Cuando no exista una secuencia clara de HH/HL o LL/LH.

En este estado:

No se permitirán operaciones.

---

# BOS (Break of Structure)

Un BOS ocurre cuando el precio rompe el último máximo o mínimo estructural en la dirección de la tendencia.

Debe producirse mediante el cierre de una vela.

No se considerarán válidas las rupturas únicamente por mecha.

---

# Reglas del BOS

Debe existir:

* Cierre de vela.
* Ruptura clara.
* Distancia mínima configurable.
* Confirmación estructural.

---

# Filtros de Ruido

El algoritmo ignorará pivotes que:

* Se formen dentro del rango de la vela anterior.
* No generen desplazamiento suficiente.
* Estén demasiado próximos entre sí.
* Sean consecuencia de baja volatilidad.

---

# Salida del módulo

El Structure Engine deberá entregar al resto del sistema:

* Tendencia actual.
* Último HH.
* Último HL.
* Último LH.
* Último LL.
* Último BOS.
* Dirección de la estructura.
* Fuerza estructural.

Toda esta información será consumida posteriormente por:

* Liquidity Engine.
* CHOCH Engine.
* Entry Manager.

---

# Configuración

Los siguientes parámetros deberán declararse únicamente en Config.mqh:

* PivotStrength
* MinimumSwingDistance
* MinimumBreakDistance
* StructureLookback

No deberán existir valores fijos dentro del código del módulo.

---

# Rendimiento

El algoritmo deberá evitar recalcular toda la estructura en cada tick.

Siempre que sea posible:

* Recalcular únicamente cuando cierre una nueva vela.
* Actualizar únicamente los últimos pivotes afectados.

Esto reduce significativamente el consumo de CPU durante backtesting y ejecución en tiempo real.

---

# Objetivo Final

El Structure Engine debe proporcionar una representación objetiva, estable y reutilizable de la estructura del mercado.

Todos los módulos posteriores asumirán que la información producida por este componente es correcta y consistente.
# 10_StructureEngine.md (Parte 2)

# Algoritmo de Detección de Swings

## Objetivo

Detectar pivotes estructurales de forma consistente, sin repintado y con el menor ruido posible.

El algoritmo trabajará únicamente sobre velas cerradas.

Nunca deberá utilizar información de una vela que aún se está formando.

---

# Entrada

El algoritmo recibe:

* OHLC del símbolo actual.
* Timeframe.
* PivotStrength.
* Lookback.

---

# Salida

Lista ordenada de Swings.

Cada Swing deberá contener:

```text
Tipo

Swing High
o
Swing Low

------------

Precio

------------

Fecha

------------

Índice de vela

------------

Estado

Confirmado
```

---

# Algoritmo General

Cada vez que cierre una vela:

Actualizar únicamente los últimos pivotes.

No recorrer miles de velas nuevamente.

---

# Paso 1

Esperar cierre de vela.

```text
Nueva vela

↓

Actualizar estructura

↓

No hacer cálculos durante la formación de la vela.
```

---

# Paso 2

Buscar posible Swing High.

Sea N = PivotStrength.

Una vela será candidata únicamente si:

```text
High(i)

>

High(i-1)

High(i-2)

...

High(i-N)

y

High(i+1)

High(i+2)

...

High(i+N)
```

Debe ser estrictamente mayor.

No se aceptan empates.

---

# Paso 3

Buscar Swing Low.

Regla equivalente.

```text
Low(i)

<

Low(i-1)

Low(i-2)

...

Low(i-N)

y

Low(i+1)

Low(i+2)

...

Low(i+N)
```

---

# Confirmación

Un Swing únicamente existirá cuando hayan cerrado las velas necesarias.

Ejemplo.

PivotStrength = 3.

El posible pivote deberá esperar tres velas posteriores.

Esto elimina el repintado.

---

# Evitar Swings Duplicados

No podrán existir dos Swing High consecutivos.

Ejemplo incorrecto.

```text
HH

HH
```

Entre ellos deberá existir un Swing Low.

---

Igualmente.

No podrán existir dos Swing Low consecutivos.

---

# Reemplazo de Swings

Si antes de confirmar aparece un máximo superior.

El Swing anterior será descartado.

Se conservará únicamente el más fuerte.

---

# Construcción de la Estructura

Una vez confirmados los pivotes.

Se compararán únicamente con el último pivote del mismo tipo.

Ejemplo.

```text
Swing High nuevo

>

Swing High anterior

↓

Higher High
```

---

```text
Swing High nuevo

<

Swing High anterior

↓

Lower High
```

---

Para mínimos.

```text
Swing Low nuevo

>

Swing Low anterior

↓

Higher Low
```

---

```text
Swing Low nuevo

<

Swing Low anterior

↓

Lower Low
```

---

# Memoria Estructural

El algoritmo deberá recordar únicamente los pivotes relevantes.

No necesita almacenar todos los pivotes históricos.

Variables recomendadas:

```text
Último HH

Último HL

Último LH

Último LL

Último Swing High

Último Swing Low
```

---

# BOS

Después de construir la estructura.

Se verificará si existe ruptura.

Condiciones.

* Cierre de vela.
* Distancia mínima.
* Rompe último nivel estructural.

Si se cumplen.

Registrar BOS.

---

# Cambio de Tendencia

No cambiar inmediatamente.

Debe cumplirse.

Ejemplo alcista.

```text
HH

↓

HL

↓

BOS

↓

Nueva tendencia
```

Lo mismo para ventas.

---

# Ruido

Ignorar pivotes si:

La distancia entre ellos es menor que:

MinimumSwingDistance.

---

También ignorar.

Velas extremadamente pequeñas.

Velas sin desplazamiento.

Movimientos laterales.

---

# Rendimiento

No recorrer todo el histórico.

Actualizar únicamente.

Las últimas velas.

Últimos pivotes.

Última estructura.

---

# Casos Especiales

## Noticias

Durante noticias.

Puede aparecer una vela enorme.

No asumir automáticamente un BOS.

Esperar cierre.

---

## Velas Doji

Nunca crear un Swing únicamente por un Doji.

---

## Gaps

Registrar.

Pero esperar confirmación estructural.

---

## Mercado Lateral

Si durante muchas velas.

No existen HH/HL.

Ni LL/LH.

Clasificar.

Range.

---

# Funciones sugeridas

```text
DetectSwingHigh()

DetectSwingLow()

UpdateStructure()

UpdateTrend()

DetectBOS()

ValidateSwing()

RemoveNoise()

GetCurrentTrend()

GetLastSwing()

GetStructure()
```

---

# Información entregada al resto del EA

```text
Tendencia

Swing High

Swing Low

HH

HL

LH

LL

BOS

Strength

Fecha

Precio
```

---

# Notas para GitHub Copilot

Este módulo NO debe:

* Detectar liquidez.
* Detectar CHOCH.
* Detectar FVG.
* Abrir operaciones.
* Dibujar objetos gráficos innecesarios.

Su única responsabilidad es interpretar la estructura del mercado y proporcionar una representación consistente al resto del sistema.

Todo el código deberá ser independiente y reutilizable por otros módulos.
