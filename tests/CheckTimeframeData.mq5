#property strict
#property script_show_inputs
#property description "SmartMoneyEA - diagnostic: verifies that every timeframe used by the documented H4->H1->M30->M15->M5->M1 hierarchy is synchronized and has usable history for the current symbol. Read-only: places no orders, draws no objects."

#include "../src/Core/Config.mqh"
#include "../src/Core/Utils.mqh"

//+------------------------------------------------------------------+
//| Report the availability of one timeframe's series                |
//+------------------------------------------------------------------+
void CheckTimeframe(const string label,
                    const ENUM_TIMEFRAMES timeframe)
  {
   bool synchronized =
      (SeriesInfoInteger(_Symbol, timeframe, SERIES_SYNCHRONIZED) != 0);

   int bars =
      iBars(_Symbol, timeframe);

   datetime oldest =
      (bars > 0) ? iTime(_Symbol, timeframe, bars - 1) : 0;

   datetime newest =
      (bars > 0) ? iTime(_Symbol, timeframe, 0) : 0;

   double lastHigh =
      (bars > 0) ? iHigh(_Symbol, timeframe, 0) : 0.0;

   double lastLow =
      (bars > 0) ? iLow(_Symbol, timeframe, 0) : 0.0;

   bool usable =
      synchronized &&
      bars > 0 &&
      oldest > 0 &&
      newest > 0 &&
      lastHigh > 0.0 &&
      lastLow > 0.0;

   PrintFormat(
      "%-5s | %-9s | sync=%-5s | bars=%-7d | oldest=%s | newest=%s | %s",
      label,
      EnumToString(timeframe),
      synchronized ? "true" : "false",
      bars,
      (oldest > 0) ? TimeToString(oldest, TIME_DATE) : "-",
      (newest > 0) ? TimeToString(newest, TIME_DATE | TIME_MINUTES) : "-",
      usable ? "OK" : "NOT READY"
   );
  }


//+------------------------------------------------------------------+
//| Script entry point                                                |
//+------------------------------------------------------------------+
void OnStart(void)
  {
   Print("========================================");
   Print("SmartMoneyEA | Timeframe data availability check");
   Print("Symbol: ", _Symbol);
   Print("========================================");

   CheckTimeframe("H4",  Trend_Timeframe_H4);
   CheckTimeframe("H1",  Trend_Timeframe_H1);
   CheckTimeframe("M30", Liquidity_Timeframe_M30);
   CheckTimeframe("M15", Refinement_Timeframe_M15);
   CheckTimeframe("M5",  Engulfing_Timeframe_M5);
   CheckTimeframe("M1",  CHOCH_Timeframe_M1);

   Print("========================================");
   Print("Done. A timeframe marked NOT READY needs its history");
   Print("downloaded/synchronized (open that timeframe's chart once,");
   Print("or wait for the terminal to finish syncing) before any");
   Print("engine that reads it can be trusted.");
   Print("========================================");
  }
