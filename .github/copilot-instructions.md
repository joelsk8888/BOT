# GitHub Copilot Instructions

## Project Overview

This repository contains a professional MetaTrader 5 Expert Advisor (EA) written in MQL5.

The strategy is based on **Smart Money Concepts (SMC)** and is specifically designed for **XAUUSD (Gold)**.

The goal of this project is to build a modular, maintainable and statistically validated trading system.

Every implementation must follow the project architecture and documentation before writing any code.

---

# General Principles

* Prioritize readability over clever code.
* Write modular code.
* Avoid duplicated logic.
* Follow the Single Responsibility Principle.
* Prefer classes over procedural code.
* Keep functions small and focused.
* Every module should be reusable.
* Never hardcode strategy values.
* Every configurable value must be declared in `Core/Config.mqh`.

---

# Project Architecture

```
src/

Analysis/
    SwingDetector
    MarketStructure
    Trend
    Liquidity
    BOS
    CHOCH
    FairValueGap
    OrderBlocks

Confirmation/
    Engulfing
    CandlePatterns
    ConfirmationScore

Core/
    Config
    Logger
    Utils

Entry/
    EntryFilters
    EntryManager

Filters/
    NewsFilter
    SessionFilter
    SpreadFilter

Trade/
    TradeManager
    RiskManager
    BreakEven
    PartialClose
    TrailingStructure
```

Every module has exactly one responsibility.

---

# Trading Philosophy

The EA follows this sequence:

1. Determine higher timeframe trend.
2. Detect liquidity targets.
3. Wait for liquidity sweep.
4. Detect CHOCH.
5. Validate displacement.
6. Detect Fair Value Gap.
7. Wait for mitigation if enabled.
8. Detect engulfing confirmation.
9. Calculate setup score.
10. Open trade.
11. Manage position.

Never skip steps unless explicitly configured.

---

# Timeframe Hierarchy

Trend Analysis

* H4
* H1

Liquidity

* M30
* M15

Confirmation

* M5
* M1

Do not mix responsibilities between timeframes.

---

# Coding Rules

Use descriptive names.

Good:

```
DetectLiquiditySweep()

CalculateScore()

FindNearestFVG()
```

Avoid names like:

```
test()

run()

calc()

check()
```

---

# Classes

Prefer one class per module.

Example:

```
CSwingDetector

CLiquidityEngine

CFVGEngine

CTradeManager
```

Avoid giant classes.

---

# Global Variables

Avoid global variables whenever possible.

Prefer encapsulation.

---

# Magic Numbers

Never use magic numbers.

Every threshold must be configurable through Config.mqh.

---

# Logging

Every important event must be logged.

Examples:

* Trend changed
* BOS detected
* CHOCH detected
* Liquidity sweep
* Entry
* Partial close
* BreakEven
* Trade closed

Use Logger.mqh.

Never use Print() directly except for debugging.

---

# Trade Management

Only TradeManager may:

* Open positions
* Modify positions
* Close positions

No other module should execute trades.

---

# Risk Management

Only RiskManager handles:

* Daily loss limit
* Position sizing
* Partial closes
* Break Even
* Trailing Stop

No risk logic outside this module.

---

# Entry Rules

Only EntryManager may decide if a trade is allowed.

It must use information from:

* Trend
* Liquidity
* CHOCH
* FVG
* ConfirmationScore
* Filters

---

# Filters

Filters never generate signals.

They only invalidate signals.

Current filters:

* Spread
* News
* Session

---

# Score System

Trading decisions are score-based.

Never use binary decisions when a scoring model exists.

Each confirmation contributes to the final score.

The minimum score required must be configurable.

---

# Performance

Avoid unnecessary loops.

Do not recalculate the entire history every tick.

Cache data whenever possible.

Only update the newest candles.

---

# Backtesting

All modules must work correctly inside the MT5 Strategy Tester.

Avoid non-deterministic behavior.

No repainting.

No future candle references.

---

# Documentation

Before implementing a feature, always consult the corresponding document inside `/docs`.

If documentation and code disagree, documentation has priority.

---

# Future Development

The architecture should allow future support for:

* Multi-symbol
* Multi-timeframe optimization
* Machine Learning filters
* AI-assisted optimization
* Portfolio management

Do not make architectural decisions that block future expansion.

---

# What Copilot Should Never Do

Never invent trading rules.

Never modify the trading strategy without explicit request.

Never remove existing architecture.

Never merge module responsibilities.

Never duplicate code.

Never ignore the project documentation.

Never implement shortcuts that reduce maintainability.

Always prefer clean, modular and extensible solutions.
