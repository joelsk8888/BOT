# SmartMoneyEA v1.0

## Objetivo

Desarrollar un Expert Advisor (EA) para MetaTrader 5 especializado en XAUUSD, basado en Smart Money Concepts (SMC).

El objetivo del sistema es detectar zonas de liquidez con alta probabilidad de reacción, esperar una barrida de dicha liquidez y confirmar un posible cambio de dirección mediante estructura del mercado y acción del precio antes de ejecutar una operación.

El proyecto no busca únicamente automatizar una estrategia, sino construir una plataforma de investigación que permita validar estadísticamente cada regla mediante backtesting y datos reales.

---

# Activo

- XAUUSD

Versión 1.0 enfocada únicamente en el oro.

---

# Temporalidades

| Temporalidad | Función |
|--------------|---------|
| H4 | Determinar la tendencia principal |
| H1 | Confirmar la tendencia |
| M30 | Buscar zonas de liquidez |
| M15 | Refinar las zonas de liquidez |
| M5 | Confirmación mediante vela envolvente |
| M1 | Confirmación mediante CHOCH |

---

# Flujo General

El EA seguirá siempre el siguiente flujo:

1. Analizar la estructura del mercado en H4.

2. Confirmar el contexto en H1.

3. Detectar zonas importantes de liquidez en H1, M30 y M15.

4. Esperar que el precio barra una de dichas zonas.

5. Detectar un CHOCH válido en M1.

6. Detectar un desplazamiento (Displacement).

7. Detectar la aparición de un Fair Value Gap.

8. Esperar, si está habilitado, la mitigación del FVG.

9. Buscar una vela envolvente válida en M5.

10. Abrir una única operación.

11. Gestionar automáticamente la operación.

12. Registrar todos los datos de la operación.

---

# Filosofía

El sistema nunca intentará adivinar el mercado.

Siempre esperará que el mercado muestre intención mediante:

- Contexto.
- Liquidez.
- Barrida.
- Cambio de estructura.
- Desplazamiento.
- Desequilibrio.
- Confirmación.

Solo cuando el contexto sea favorable se permitirá abrir una operación.

---

# Confirmaciones

## Confirmaciones obligatorias

- Contexto HTF
- Liquidez
- Barrida
- CHOCH

## Confirmaciones opcionales

- Fair Value Gap
- Mitigación del FVG
- Vela envolvente
- Order Block (futuro)
- Premium / Discount (futuro)

Todas podrán activarse o desactivarse mediante parámetros.

---

# Gestión

El sistema permitirá distintos modos de gestión.

- TP fijo.
- TP por siguiente liquidez.
- Parciales.
- Trailing por estructura.
- Break Even.
- Riesgo diario configurable.

Inicialmente solo podrá existir una operación abierta sobre XAUUSD.

---

# Registro

Cada operación almacenará información suficiente para realizar análisis estadísticos posteriores.

Entre otros datos:

- Fecha.
- Hora.
- Compra/Venta.
- Tendencia H4.
- Tendencia H1.
- Liquidez utilizada.
- CHOCH.
- Displacement.
- Fair Value Gap.
- Mitigación.
- Envolvente.
- Resultado.
- Beneficio/Pérdida.
- Duración.
- Motivo de salida.

---

# Objetivo del proyecto

Construir un Expert Advisor modular, escalable y completamente configurable que permita validar científicamente una estrategia basada en Smart Money Concepts mediante miles de operaciones de backtesting antes de utilizar dinero real.