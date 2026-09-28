# SmartMoneyEA

Expert Advisor para MetaTrader 5 basado en Smart Money Concepts (SMC), orientado inicialmente a XAUUSD.

## Estado actual

En desarrollo activo, por fases. Ver `docs/06_Roadmap.md` para la visión general de la estrategia y el historial de mensajes de commit de la rama `claude-development` para el estado real de cada motor.

`Enable_Trading = false` durante todo el desarrollo de los motores de análisis. No se ejecutan operaciones reales hasta que el Trade Engine (fase dedicada del roadmap) sea implementado y validado explícitamente.

## Estructura

```
docs/         Especificación funcional de cada motor
experts/      Punto de entrada del EA (.mq5) y el controlador principal
src/
  Core/           Config, Logger, Utils
  Analysis/       SwingDetector, MarketStructure, Trend, BOS, CHOCH, Liquidity, FVG, OrderBlocks
  Confirmation/   Engulfing, CandlePatterns, ConfirmationScore
  Entry/          Filtros y manejo de entradas
  Filters/        Spread, sesión, noticias
  Trade/          Gestión de posiciones, riesgo, break even, trailing
  Visualization/  Renderers (solo dibujan, no calculan)
research/    Notas de investigación y resultados de backtesting
```

## Compilar

Abrir `experts/SmartMoneyEA_Test.mq5` en MetaEditor y compilar (F7), o vía línea de comandos:

```
"C:\Program Files\MetaTrader 5\MetaEditor64.exe" /compile:"experts\SmartMoneyEA_Test.mq5" /log
```

Los `#include` son relativos al archivo fuente, por lo que el proyecto compila sin necesidad de copiarlo dentro de la carpeta de datos del terminal.

## Rama de desarrollo

Todo el trabajo activo ocurre en `claude-development`. `main` se actualiza únicamente mediante merge explícito una vez validada cada fase.
