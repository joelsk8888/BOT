# Definiciones del SmartMoneyEA

Este documento contiene todas las definiciones oficiales utilizadas por el Expert Advisor.

Ningún módulo podrá utilizar una definición diferente a las aquí descritas.

---

# 1. Tendencia

La tendencia representa la dirección predominante del mercado.

Estados posibles:

- Bullish
- Bearish
- Range

La tendencia será determinada mediante la estructura del mercado y NO mediante indicadores tradicionales.

---

# 2. Swing High

Un Swing High es un máximo relevante que representa una posible zona de liquidez.

Será utilizado para:

- Detectar HH
- Detectar LH
- Detectar Liquidez

---

# 3. Swing Low

Un Swing Low es un mínimo relevante que representa una posible zona de liquidez.

Será utilizado para:

- Detectar HL
- Detectar LL
- Detectar Liquidez

---

# 4. Higher High (HH)

Un HH ocurre cuando un nuevo Swing High supera el Swing High anterior.

Representa continuación alcista.

---

# 5. Higher Low (HL)

Un HL ocurre cuando un Swing Low permanece por encima del Swing Low anterior.

Representa fortaleza compradora.

---

# 6. Lower High (LH)

Un LH ocurre cuando un Swing High queda por debajo del Swing High anterior.

Representa debilidad compradora.

---

# 7. Lower Low (LL)

Un LL ocurre cuando un Swing Low rompe el Swing Low anterior.

Representa continuación bajista.

---

# 8. Liquidez

El EA considerará como zonas de liquidez:

- Equal Highs
- Equal Lows
- Swing Highs
- Swing Lows
- Daily High
- Daily Low
- Weekly High
- Weekly Low

Todas estas zonas serán consideradas posibles objetivos del precio.

---

# 9. Barrida de Liquidez

Una barrida ocurre cuando el precio rompe temporalmente una zona de liquidez y posteriormente vuelve al rango anterior.

La barrida indica una posible captura de liquidez antes de un cambio de dirección.

---

# 10. CHOCH

Un Change of Character (CHOCH) representa el primer cambio importante en la estructura del mercado.

Para considerarse válido deberá romper la estructura previa en dirección contraria al movimiento anterior.

El CHOCH será utilizado como la primera confirmación de entrada.

---

# 11. BOS

El Break of Structure representa la continuación de la tendencia dominante.

No será utilizado inicialmente como disparador de entrada, pero sí como información estructural.

---

# 12. Displacement

Un Displacement representa un movimiento impulsivo fuerte.

Debe demostrar intención institucional.

Será utilizado para validar el CHOCH.

---

# 13. Fair Value Gap (FVG)

Un Fair Value Gap representa un desequilibrio del mercado generado por un movimiento impulsivo.

El EA podrá:

- Detectarlo
- Dibujarlo
- Medirlo
- Esperar su mitigación

Será utilizado como una confirmación adicional.

---

# 14. Mitigación

La mitigación ocurre cuando el precio vuelve a visitar un Fair Value Gap.

Dependiendo de la configuración del EA, podrá exigirse dicha mitigación antes de abrir una operación.

---

# 15. Vela Envolvente

Una vela envolvente representa una fuerte intención del mercado.

Inicialmente se utilizará la envolvente del cuerpo de la vela.

Será la última confirmación antes de ejecutar la operación.

---

# 16. Entrada

Una operación únicamente podrá abrirse cuando se cumplan las condiciones definidas por la estrategia.

No se permitirán entradas anticipadas.

---

# 17. Gestión

La gestión podrá realizarse mediante distintos modos configurables.

Entre ellos:

- TP fijo
- TP por Liquidez
- Parciales
- Trailing por estructura
- Break Even

---

# 18. Registro

Todas las decisiones del EA deberán quedar registradas.

Esto permitirá realizar análisis estadísticos para mejorar la estrategia.