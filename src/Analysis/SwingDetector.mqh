#ifndef SMARTMONEYEA_SWINGDETECTOR_MQH
#define SMARTMONEYEA_SWINGDETECTOR_MQH

#include "../Core/Config.mqh"
#include "../Core/Utils.mqh"

//+------------------------------------------------------------------+
//| SmartMoneyEA - Swing Detector                                    |
//+------------------------------------------------------------------+
//| Detects confirmed Swing High / Swing Low pivots on closed bars.  |
//|                                                                  |
//| This module ONLY detects pivots.                                 |
//| It does NOT interpret trend, liquidity or structure.              |
//|                                                                  |
//| Processing model (FASE 0):                                       |
//| - The first successful Update() call performs a single bounded   |
//|   backfill over the currently available history, so swings that  |
//|   already exist when the EA is attached are not lost.            |
//| - Every subsequent Update() call only evaluates the candidates    |
//|   that became newly confirmable since the last processed bar     |
//|   (normally just one, when exactly one new bar has closed).       |
//| - No full-history rescan happens on a steady-state tick.          |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Swing types                                                      |
//+------------------------------------------------------------------+

enum ESwingType
  {
   SWING_TYPE_NONE = 0,
   SWING_TYPE_HIGH = 1,
   SWING_TYPE_LOW  = 2
  };


//+------------------------------------------------------------------+
//| Swing point                                                      |
//+------------------------------------------------------------------+

struct SwingPoint
  {
   string           symbol;
   ENUM_TIMEFRAMES  timeframe;

   datetime         time;
   int              shift;

   double           price;

   ESwingType       type;

   bool             confirmed;
  };


//+------------------------------------------------------------------+
//| Swing Detector                                                   |
//+------------------------------------------------------------------+

class CSwingDetector
  {
private:

   string          m_symbol;
   ENUM_TIMEFRAMES m_timeframe;

   int             m_pivotStrength;

   // Time of the newest candidate shift that has already been
   // evaluated (both Swing High and Swing Low checks performed).
   // 0 means "nothing processed yet" -> triggers the one-time backfill.
   datetime        m_lastProcessedTime;

   // Time of bar shift 0 the last time Update() ran. Used as a cheap
   // gate so we don't even touch iBars()/iBarShift() when no new bar
   // has closed since the previous call.
   datetime        m_lastSeenBarZeroTime;

   bool            m_newSwingDetected;

   SwingPoint      m_swings[];


public:

   //+------------------------------------------------------------------+
   //| Constructor                                                       |
   //+------------------------------------------------------------------+
   CSwingDetector(void)
     {
      m_symbol              = _Symbol;
      m_timeframe           = PERIOD_CURRENT;
      m_pivotStrength       = 2;
      m_lastProcessedTime   = 0;
      m_lastSeenBarZeroTime = 0;
      m_newSwingDetected    = false;

      ArrayResize(m_swings,0);
     }


   //+------------------------------------------------------------------+
   //| Initialize                                                       |
   //+------------------------------------------------------------------+
   void Initialize(const string symbol,
                   const ENUM_TIMEFRAMES timeframe)
     {
      m_symbol    = symbol;
      m_timeframe = timeframe;

      m_pivotStrength =
         (Pivot_Strength > 0)
         ? Pivot_Strength
         : 2;

      m_lastProcessedTime   = 0;
      m_lastSeenBarZeroTime = 0;
      m_newSwingDetected    = false;

      ArrayResize(m_swings,0);

      Print(
         "SWING DETECTOR | initialized | symbol=",
         m_symbol,
         " | timeframe=",
         EnumToString(m_timeframe),
         " | pivot=",
         m_pivotStrength
      );
     }


   //+------------------------------------------------------------------+
   //| Update                                                           |
   //|                                                                  |
   //| Returns true only when at least one new confirmed swing was      |
   //| added during this call.                                          |
   //+------------------------------------------------------------------+
   bool Update(void)
     {
      m_newSwingDetected = false;

      if(StringLen(m_symbol) == 0)
         return false;


      // ---------------------------------------------------------------
      // The terminal may still be downloading/synchronizing history for
      // this symbol+timeframe (freshly attached EA, terminal just
      // started, symbol never charted before, ...). Reading iBars()/
      // iTime() before synchronization finishes can return a partial or
      // stale series, which would look like "not enough bars" or, worse,
      // a misleadingly small-but-non-zero bar count. Wait for the
      // terminal to confirm the series is synchronized before trusting it.
      // ---------------------------------------------------------------

      if(!SeriesInfoInteger(m_symbol, m_timeframe, SERIES_SYNCHRONIZED))
        {
         Print(
            "SWING DETECTOR | waiting for series synchronization | symbol=",
            m_symbol,
            " | timeframe=",
            EnumToString(m_timeframe)
         );

         return false;
        }


      // ---------------------------------------------------------------
      // Cheap gate: skip all work while the current bar is still
      // forming. We only ever evaluate closed bars, so nothing can
      // change structurally until a new bar opens.
      // ---------------------------------------------------------------

      datetime barZeroTime =
         iTime(
            m_symbol,
            m_timeframe,
            0
         );

      bool firstRun =
         (m_lastProcessedTime == 0);

      if(!firstRun &&
         barZeroTime > 0 &&
         barZeroTime == m_lastSeenBarZeroTime)
        {
         return false;
        }


      int barsCount =
         iBars(
            m_symbol,
            m_timeframe
         );

      if(barsCount <= 0)
        {
         Print(
            "SWING DETECTOR | ERROR | no bars | symbol=",
            m_symbol,
            " | timeframe=",
            EnumToString(m_timeframe)
         );

         return false;
        }


      // Need enough candles around the pivot.
      int minimumBars =
         (m_pivotStrength * 2) + 5;

      if(barsCount < minimumBars)
        {
         Print(
            "SWING DETECTOR | waiting for bars | bars=",
            barsCount,
            " | required=",
            minimumBars
         );

         return false;
        }


      // Oldest candidate -> newest candidate.
      //
      // Example with pivot=2:
      //
      // shift 5
      // shift 4
      // shift 3
      //
      // The newest valid candidate is shift=3 because we need two
      // newer closed candles to confirm the pivot.

      int newestCandidate =
         m_pivotStrength + 1;

      int oldestAvailable =
         barsCount - m_pivotStrength - 1;

      if(oldestAvailable < newestCandidate)
         return false;


      int oldestCandidate;

      if(firstRun)
        {
         // ---------------------------------------------------------------
         // One-time backfill: scan all currently available history so
         // swings that already existed before the EA was attached are
         // not lost. This never runs again after it succeeds once.
         // ---------------------------------------------------------------

         oldestCandidate = oldestAvailable;

         Print(
            "SWING DETECTOR | first run | performing one-time backfill | bars=",
            barsCount
         );
        }
      else
        {
         // ---------------------------------------------------------------
         // Incremental step: only (re)evaluate candidates strictly newer
         // than the last one we already processed. In the normal case of
         // one new bar closing per call this is a single candidate.
         // ---------------------------------------------------------------

         int lastProcessedShift =
            iBarShift(
               m_symbol,
               m_timeframe,
               m_lastProcessedTime,
               true
            );

         if(lastProcessedShift < 0)
           {
            // The reference bar is no longer part of the series
            // (e.g. history was reloaded). Fall back to a bounded
            // backfill instead of silently losing candidates.
            oldestCandidate = oldestAvailable;

            Print(
               "SWING DETECTOR | reference bar not found | falling back to backfill | bars=",
               barsCount
            );
           }
         else
           {
            oldestCandidate = lastProcessedShift - 1;

            if(oldestCandidate > oldestAvailable)
               oldestCandidate = oldestAvailable;
           }
        }


      if(oldestCandidate < newestCandidate)
        {
         m_lastSeenBarZeroTime = barZeroTime;
         return false;
        }


      bool detected = false;


      for(int shift = oldestCandidate;
          shift >= newestCandidate;
          shift--)
        {
         datetime candleTime =
            iTime(
               m_symbol,
               m_timeframe,
               shift
            );

         if(candleTime <= 0)
            continue;


         // ------------------------------------------------------------
         // Swing High
         // ------------------------------------------------------------

         if(IsConfirmedSwingHigh(shift,barsCount))
           {
            if(AddSwing(
                  shift,
                  SWING_TYPE_HIGH))
              {
               detected = true;
              }
           }


         // ------------------------------------------------------------
         // Swing Low
         // ------------------------------------------------------------

         if(IsConfirmedSwingLow(shift,barsCount))
           {
            if(AddSwing(
                  shift,
                  SWING_TYPE_LOW))
              {
               detected = true;
              }
           }
        }


      // ---------------------------------------------------------------
      // Advance the incremental cursor to the newest candidate we just
      // evaluated, regardless of whether it produced a confirmed swing.
      // ---------------------------------------------------------------

      datetime newestCandidateTime =
         iTime(
            m_symbol,
            m_timeframe,
            newestCandidate
         );

      if(newestCandidateTime > 0)
         m_lastProcessedTime = newestCandidateTime;

      m_lastSeenBarZeroTime = barZeroTime;


      if(detected)
        {
         m_newSwingDetected = true;

         Print(
            "SWING DETECTOR | swings detected | total=",
            GetSwingCount()
         );
        }


      return detected;
     }


   //+------------------------------------------------------------------+
   //| Is new swing detected                                            |
   //+------------------------------------------------------------------+
   bool HasNewConfirmedSwing(void) const
     {
      return m_newSwingDetected;
     }


   //+------------------------------------------------------------------+
   //| Reset flag                                                       |
   //+------------------------------------------------------------------+
   void ResetNewSwingFlag(void)
     {
      m_newSwingDetected = false;
     }


   //+------------------------------------------------------------------+
   //| Swing count                                                      |
   //+------------------------------------------------------------------+
   int GetSwingCount(void) const
     {
      return ArraySize(m_swings);
     }


   //+------------------------------------------------------------------+
   //| Get swing                                                        |
   //+------------------------------------------------------------------+
   bool GetSwing(const int index,
                 SwingPoint &swing) const
     {
      int count =
         ArraySize(m_swings);

      if(index < 0 || index >= count)
         return false;

      swing =
         m_swings[index];

      swing.shift =
         iBarShift(
            m_symbol,
            m_timeframe,
            swing.time,
            true
         );

      return true;
     }


   //+------------------------------------------------------------------+
   //| Get last swing                                                   |
   //+------------------------------------------------------------------+
   bool GetLastSwing(SwingPoint &swing) const
     {
      int count =
         ArraySize(m_swings);

      if(count <= 0)
         return false;

      return GetSwing(
         count - 1,
         swing
      );
     }


   //+------------------------------------------------------------------+
   //| Get last high                                                    |
   //+------------------------------------------------------------------+
   bool GetLastHighSwing(SwingPoint &swing) const
     {
      int count =
         ArraySize(m_swings);

      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_swings[i].type ==
            SWING_TYPE_HIGH)
           {
            return GetSwing(
               i,
               swing
            );
           }
        }

      return false;
     }


   //+------------------------------------------------------------------+
   //| Get last low                                                     |
   //+------------------------------------------------------------------+
   bool GetLastLowSwing(SwingPoint &swing) const
     {
      int count =
         ArraySize(m_swings);

      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_swings[i].type ==
            SWING_TYPE_LOW)
           {
            return GetSwing(
               i,
               swing
            );
           }
        }

      return false;
     }


   //+------------------------------------------------------------------+
   //| Clear                                                            |
   //+------------------------------------------------------------------+
   void Clear(void)
     {
      ArrayResize(
         m_swings,
         0
      );

      m_lastProcessedTime   = 0;
      m_lastSeenBarZeroTime = 0;
      m_newSwingDetected    = false;
     }


private:

   //+------------------------------------------------------------------+
   //| Confirmed Swing High                                             |
   //+------------------------------------------------------------------+
   bool IsConfirmedSwingHigh(const int shift,
                             const int barsCount) const
     {
      if(shift <= m_pivotStrength)
         return false;

      if(shift >=
         barsCount - m_pivotStrength)
         return false;


      double pivotHigh =
         iHigh(
            m_symbol,
            m_timeframe,
            shift
         );

      if(pivotHigh <= 0.0)
         return false;


      for(int i = 1;
          i <= m_pivotStrength;
          i++)
        {
         double newerHigh =
            iHigh(
               m_symbol,
               m_timeframe,
               shift - i
            );

         double olderHigh =
            iHigh(
               m_symbol,
               m_timeframe,
               shift + i
            );


         if(newerHigh >= pivotHigh)
            return false;

         if(olderHigh >= pivotHigh)
            return false;
        }


      return true;
     }


   //+------------------------------------------------------------------+
   //| Confirmed Swing Low                                              |
   //+------------------------------------------------------------------+
   bool IsConfirmedSwingLow(const int shift,
                            const int barsCount) const
     {
      if(shift <= m_pivotStrength)
         return false;

      if(shift >=
         barsCount - m_pivotStrength)
         return false;


      double pivotLow =
         iLow(
            m_symbol,
            m_timeframe,
            shift
         );

      if(pivotLow <= 0.0)
         return false;


      for(int i = 1;
          i <= m_pivotStrength;
          i++)
        {
         double newerLow =
            iLow(
               m_symbol,
               m_timeframe,
               shift - i
            );

         double olderLow =
            iLow(
               m_symbol,
               m_timeframe,
               shift + i
            );


         if(newerLow <= pivotLow)
            return false;

         if(olderLow <= pivotLow)
            return false;
        }


      return true;
     }


   //+------------------------------------------------------------------+
   //| Add swing                                                        |
   //+------------------------------------------------------------------+
   bool AddSwing(const int shift,
                 const ESwingType type)
     {
      if(shift <= 0)
         return false;


      datetime swingTime =
         iTime(
            m_symbol,
            m_timeframe,
            shift
         );

      if(swingTime <= 0)
         return false;


      double price = 0.0;


      if(type == SWING_TYPE_HIGH)
        {
         price =
            iHigh(
               m_symbol,
               m_timeframe,
               shift
            );
        }
      else
      if(type == SWING_TYPE_LOW)
        {
         price =
            iLow(
               m_symbol,
               m_timeframe,
               shift
            );
        }
      else
        {
         return false;
        }


      if(price <= 0.0)
         return false;


      // ---------------------------------------------------------------
      // Prevent duplicates.
      // ---------------------------------------------------------------

      int count =
         ArraySize(m_swings);


      for(int i = count - 1;
          i >= 0;
          i--)
        {
         // Swings are appended in chronological order, so once we walk
         // past a swing older than the candidate there is nothing more
         // to compare against.
         if(m_swings[i].time < swingTime)
            break;

         if(m_swings[i].time == swingTime &&
            m_swings[i].type == type)
            return false;
        }


      // ---------------------------------------------------------------
      // Add.
      // ---------------------------------------------------------------

      int index =
         count;


      ArrayResize(
         m_swings,
         index + 1
      );


      m_swings[index].symbol =
         m_symbol;

      m_swings[index].timeframe =
         m_timeframe;

      m_swings[index].time =
         swingTime;

      m_swings[index].shift =
         shift;

      m_swings[index].price =
         NormalizeDouble(
            price,
            (int)SymbolInfoInteger(
               m_symbol,
               SYMBOL_DIGITS
            )
         );

      m_swings[index].type =
         type;

      m_swings[index].confirmed =
         true;


      return true;
     }
  };

#endif // SMARTMONEYEA_SWINGDETECTOR_MQH
