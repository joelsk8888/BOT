# AGENTS.md

## SmartMoneyEA

Este proyecto desarrolla un Expert Advisor profesional para MetaTrader 5 basado en Smart Money Concepts (SMC).

El objetivo es crear un sistema modular, mantenible y orientado a investigación.

---

# Tecnología

- Lenguaje: MQL5
- Plataforma: MetaTrader 5

---

# Filosofía

Antes de escribir código:

1. Comprender el problema.
2. Revisar la documentación.
3. Implementar una única responsabilidad por módulo.
4. Escribir código limpio y reutilizable.

---

# Arquitectura

El proyecto está dividido en motores independientes.

- Structure Engine
- Trend Engine
- Liquidity Engine
- CHOCH Engine
- Displacement Engine
- Fair Value Gap Engine
- Confirmation Engine
- Scoring Engine
- Entry Engine
- Trade Manager
- Logger

Ningún motor debe asumir responsabilidades de otro.

---

# Reglas de desarrollo

- No duplicar lógica.
- No utilizar variables globales innecesarias.
- No utilizar números mágicos.
- Toda configuración debe ir en Config.mqh.
- Escribir funciones pequeñas y con nombres descriptivos.
- Comentar únicamente cuando el código no sea evidente.
- Evitar funciones excesivamente largas.

---

# Restricciones

No utilizar:

- ZigZag.
- EMA.
- RSI.
- MACD.
- Indicadores externos para detectar estructura.

Toda la estructura del mercado debe calcularse manualmente.

---

# Documentación obligatoria

Antes de modificar un módulo, revisar:

- docs/01_Estrategia.md
- docs/02_Reglas.md
- docs/05_Definiciones.md
- docs/08_Parametros.md
- docs/09_RiskManagement.md

---

# Estándares

Una clase = una responsabilidad.

No mezclar análisis de mercado con ejecución de órdenes.

No abrir operaciones fuera del Entry Engine.

No gestionar posiciones fuera del Trade Manager.

---

# Calidad

Todo código nuevo deberá:

- Compilar sin errores.
- Mantener compatibilidad con el resto de módulos.
- Seguir la arquitectura del proyecto.
- Ser fácilmente testeable.

---

# Objetivo final

El SmartMoneyEA debe ser un framework reutilizable para estrategias basadas en Smart Money Concepts, no un Expert Advisor rígido para una única estrategia.
