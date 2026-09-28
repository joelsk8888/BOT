#property strict

#include "SmartMoneyEA.mqh"

CSmartMoneyEA g_smartMoneyEA;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("========================================");
   Print("SmartMoneyEA TEST - OnInit");
   Print("Symbol: ", _Symbol);
   Print("Timeframe: ", EnumToString((ENUM_TIMEFRAMES)_Period));
   Print("========================================");

   if(!g_smartMoneyEA.Initialize(
      _Symbol,
      (ENUM_TIMEFRAMES)_Period))
     {
      Print("SmartMoneyEA initialization FAILED");
      return INIT_FAILED;
     }

   Print("SmartMoneyEA initialization OK");

   return INIT_SUCCEEDED;
  }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   g_smartMoneyEA.Update();
  }


//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print(
      "SmartMoneyEA TEST - Deinit | reason=",
      reason
   );

   g_smartMoneyEA.Shutdown();
  }
