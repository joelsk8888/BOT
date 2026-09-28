#ifndef SMARTMONEYEA_UTILS_MQH
#define SMARTMONEYEA_UTILS_MQH

//+------------------------------------------------------------------+
//| SmartMoneyEA - Utilities                                         |
//+------------------------------------------------------------------+
//| Generic reusable helper functions for the EA.                    |
//|                                                                  |
//| This module must NOT contain strategy logic, entry logic,        |
//| trading logic or market-structure logic.                         |
//+------------------------------------------------------------------+

class CUtils
  {
public:

   //+------------------------------------------------------------------+
   //| PRICE UTILITIES                                                  |
   //+------------------------------------------------------------------+

   static double NormalizePrice(const string symbol,
                                const double price)
     {
      if(!IsSymbolAvailable(symbol))
         return 0.0;

      if(!IsValidPrice(price))
         return 0.0;

      int digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);

      if(digits < 0)
         digits=0;

      return NormalizeDouble(price,digits);
     }


   static double PriceDistance(const double price1,
                               const double price2)
     {
      return MathAbs(price1-price2);
     }


   static double PointsToPriceDistance(const string symbol,
                                       const double points)
     {
      if(!IsSymbolAvailable(symbol))
         return 0.0;

      double pointValue=SymbolInfoDouble(symbol,SYMBOL_POINT);

      if(pointValue <= 0.0)
         return 0.0;

      return MathAbs(points)*pointValue;
     }


   static double PriceDistanceToPoints(const string symbol,
                                       const double distance)
     {
      if(!IsSymbolAvailable(symbol))
         return 0.0;

      double pointValue=SymbolInfoDouble(symbol,SYMBOL_POINT);

      if(pointValue <= 0.0)
         return 0.0;

      return MathAbs(distance)/pointValue;
     }


   static bool IsWithinTolerance(const string symbol,
                                 const double price1,
                                 const double price2,
                                 const double tolerance)
     {
      if(!IsSymbolAvailable(symbol))
         return false;

      if(!IsValidPrice(price1) ||
         !IsValidPrice(price2))
         return false;

      if(tolerance < 0.0)
         return false;

      return PriceDistance(price1,price2) <= tolerance;
     }


   //+------------------------------------------------------------------+
   //| ATR UTILITIES                                                    |
   //+------------------------------------------------------------------+

   static double GetATR(const string symbol,
                        const ENUM_TIMEFRAMES timeframe,
                        const int period=14,
                        const int shift=0)
     {
      if(!IsSymbolAvailable(symbol))
         return 0.0;

      if(period <= 0 || shift < 0)
         return 0.0;

      int handle=GetCachedATRHandle(
         symbol,
         timeframe,
         period
      );

      if(handle == INVALID_HANDLE)
         return 0.0;

      double atrBuffer[];

      ArraySetAsSeries(atrBuffer,true);

      int copied=CopyBuffer(
         handle,
         0,
         shift,
         1,
         atrBuffer
      );

      if(copied != 1)
         return 0.0;

      if(!MathIsValidNumber(atrBuffer[0]) ||
         atrBuffer[0] <= 0.0)
         return 0.0;

      return atrBuffer[0];
     }


   static double ATRMultipleToPriceDistance(
      const string symbol,
      const double atrMultiple,
      const ENUM_TIMEFRAMES timeframe,
      const int period=14,
      const int shift=0)
     {
      if(atrMultiple <= 0.0)
         return 0.0;

      double atrValue=GetATR(
         symbol,
         timeframe,
         period,
         shift
      );

      if(atrValue <= 0.0)
         return 0.0;

      return atrValue*atrMultiple;
     }


   //+------------------------------------------------------------------+
   //| VOLUME / LOT UTILITIES                                           |
   //+------------------------------------------------------------------+

   static double NormalizeLotSize(const string symbol,
                                  const double volume)
     {
      if(!IsSymbolAvailable(symbol))
         return 0.0;

      double minVolume=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);

      double maxVolume=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);

      double stepVolume=
         SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);

      if(minVolume <= 0.0 ||
         maxVolume <= 0.0 ||
         stepVolume <= 0.0)
         return 0.0;

      if(volume <= 0.0)
         return minVolume;

      double normalizedVolume=volume;

      //--- Clamp to broker limits
      if(normalizedVolume < minVolume)
         normalizedVolume=minVolume;

      if(normalizedVolume > maxVolume)
         normalizedVolume=maxVolume;

      //--- Round DOWN to the broker volume step
      normalizedVolume=
         MathFloor(
            normalizedVolume/stepVolume
         )*stepVolume;

      //--- Protect minimum volume
      if(normalizedVolume < minVolume)
         normalizedVolume=minVolume;

      if(normalizedVolume > maxVolume)
         normalizedVolume=maxVolume;

      //--- Normalize decimal precision
      int volumeDigits=GetVolumeDigits(stepVolume);

      return NormalizeDouble(
         normalizedVolume,
         volumeDigits
      );
     }


   static double ClampLotSize(const string symbol,
                              const double volume)
     {
      return NormalizeLotSize(
         symbol,
         volume
      );
     }


   //+------------------------------------------------------------------+
   //| CANDLE UTILITIES                                                 |
   //+------------------------------------------------------------------+

   static datetime GetCandleOpenTime(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe,
      const int shift=0)
     {
      if(!IsSymbolAvailable(symbol))
         return 0;

      if(shift < 0)
         return 0;

      return iTime(
         symbol,
         timeframe,
         shift
      );
     }


   static bool IsNewCandle(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe,
      const datetime previousOpenTime)
     {
      if(!IsSymbolAvailable(symbol))
         return false;

      datetime currentOpenTime=
         GetCandleOpenTime(
            symbol,
            timeframe,
            0
         );

      if(currentOpenTime <= 0)
         return false;

      return currentOpenTime > previousOpenTime;
     }


   static bool TryGetOHLC(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe,
      const int shift,
      double &open,
      double &high,
      double &low,
      double &close)
     {
      if(!IsSymbolAvailable(symbol))
         return false;

      if(shift < 0)
         return false;

      int barsCount=iBars(
         symbol,
         timeframe
      );

      if(barsCount <= shift)
         return false;

      MqlRates rates[];

      int copied=CopyRates(
         symbol,
         timeframe,
         shift,
         1,
         rates
      );

      if(copied != 1)
         return false;

      open=rates[0].open;
      high=rates[0].high;
      low=rates[0].low;
      close=rates[0].close;

      return true;
     }


   static bool HasEnoughBars(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe,
      const int requiredBars)
     {
      if(!IsSymbolAvailable(symbol))
         return false;

      if(requiredBars <= 0)
         return true;

      return iBars(
         symbol,
         timeframe
      ) >= requiredBars;
     }


   //+------------------------------------------------------------------+
   //| TIME UTILITIES                                                   |
   //+------------------------------------------------------------------+

   static datetime ServerTimeNow(void)
     {
      return TimeCurrent();
     }


   static bool IsValidDateTime(const datetime value)
     {
      return value > 0;
     }


   static int GetHour(const datetime value)
     {
      MqlDateTime dt;

      if(!TimeToStruct(value,dt))
         return -1;

      return dt.hour;
     }


   static int GetMinute(const datetime value)
     {
      MqlDateTime dt;

      if(!TimeToStruct(value,dt))
         return -1;

      return dt.min;
     }


   static int GetDayOfWeek(const datetime value)
     {
      MqlDateTime dt;

      if(!TimeToStruct(value,dt))
         return -1;

      return dt.day_of_week;
     }


   //+------------------------------------------------------------------+
   //| VALIDATION                                                       |
   //+------------------------------------------------------------------+

   static bool IsSymbolAvailable(const string symbol)
     {
      if(StringLen(symbol) == 0)
         return false;

      if(SymbolInfoInteger(symbol,SYMBOL_SELECT) != 0)
         return true;

      if(!SymbolSelect(symbol,true))
         return false;

      return SymbolInfoInteger(
         symbol,
         SYMBOL_SELECT
      ) != 0;
     }


   static bool IsValidPrice(const double price)
     {
      return MathIsValidNumber(price) &&
             price > 0.0;
     }


   static bool IsValidVolume(const double volume)
     {
      return MathIsValidNumber(volume) &&
             volume > 0.0;
     }


private:

   //+------------------------------------------------------------------+
   //| Cached ATR handles                                               |
   //+------------------------------------------------------------------+
   static int GetCachedATRHandle(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe,
      const int period)
     {
      static string cachedSymbols[];
      static ENUM_TIMEFRAMES cachedTimeframes[];
      static int cachedPeriods[];
      static int cachedHandles[];

      int count=ArraySize(cachedSymbols);


      //--- Search existing handle
      for(int i=0;i<count;i++)
        {
         if(cachedSymbols[i] == symbol &&
            cachedTimeframes[i] == timeframe &&
            cachedPeriods[i] == period)
           {
            return cachedHandles[i];
           }
        }


      //--- Create new ATR handle
      int handle=iATR(
         symbol,
         timeframe,
         period
      );

      if(handle == INVALID_HANDLE)
         return INVALID_HANDLE;


      //--- Store handle
      int index=count;

      ArrayResize(
         cachedSymbols,
         index+1
      );

      ArrayResize(
         cachedTimeframes,
         index+1
      );

      ArrayResize(
         cachedPeriods,
         index+1
      );

      ArrayResize(
         cachedHandles,
         index+1
      );


      cachedSymbols[index]=symbol;
      cachedTimeframes[index]=timeframe;
      cachedPeriods[index]=period;
      cachedHandles[index]=handle;


      return handle;
     }


   //+------------------------------------------------------------------+
   //| Determine volume decimal places                                 |
   //+------------------------------------------------------------------+
   static int GetVolumeDigits(const double step)
     {
      if(step >= 1.0)
         return 0;

      if(step >= 0.1)
         return 1;

      if(step >= 0.01)
         return 2;

      if(step >= 0.001)
         return 3;

      return 4;
     }
  };

#endif // SMARTMONEYEA_UTILS_MQH
