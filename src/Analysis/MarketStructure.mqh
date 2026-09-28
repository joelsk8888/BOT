#ifndef SMARTMONEYEA_MARKETSTRUCTURE_MQH
#define SMARTMONEYEA_MARKETSTRUCTURE_MQH

#include "../Core/Config.mqh"
#include "../Core/Utils.mqh"
#include "SwingDetector.mqh"

//+------------------------------------------------------------------+
//| SmartMoneyEA - Market Structure                                  |
//+------------------------------------------------------------------+
//| Converts confirmed swings into market-structure labels.           |
//|                                                                  |
//| HH = Higher High                                                 |
//| HL = Higher Low                                                  |
//| LH = Lower High                                                  |
//| LL = Lower Low                                                   |
//|                                                                  |
//| This module DOES NOT detect BOS, CHOCH, liquidity or entries.    |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Structure type                                                    |
//+------------------------------------------------------------------+

enum EStructureType
  {
   STRUCTURE_NONE = 0,

   STRUCTURE_HH,
   STRUCTURE_HL,
   STRUCTURE_LH,
   STRUCTURE_LL
  };


//+------------------------------------------------------------------+
//| Market bias                                                       |
//+------------------------------------------------------------------+

enum EMarketBias
  {
   MARKET_BIAS_NEUTRAL = 0,
   MARKET_BIAS_BULLISH,
   MARKET_BIAS_BEARISH
  };


//+------------------------------------------------------------------+
//| Structure point                                                   |
//+------------------------------------------------------------------+

struct StructurePoint
  {
   string           symbol;
   ENUM_TIMEFRAMES  timeframe;

   datetime         time;
   int              shift;

   double           price;

   ESwingType       swingType;

   EStructureType   structureType;

   bool             confirmed;
  };


//+------------------------------------------------------------------+
//| Market Structure Engine                                           |
//+------------------------------------------------------------------+

class CMarketStructure
  {
private:

   string          m_symbol;
   ENUM_TIMEFRAMES m_timeframe;

   StructurePoint  m_points[];

   EMarketBias     m_bias;

   int             m_lastSwingCount;


public:

   //+------------------------------------------------------------------+
   //| Constructor                                                      |
   //+------------------------------------------------------------------+
   CMarketStructure(void)
     {
      m_symbol        = _Symbol;
      m_timeframe     = PERIOD_CURRENT;

      m_bias          = MARKET_BIAS_NEUTRAL;

      m_lastSwingCount = 0;

      ArrayResize(
         m_points,
         0
      );
     }


   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
   ~CMarketStructure(void)
     {
     }


   //+------------------------------------------------------------------+
   //| Initialize                                                       |
   //+------------------------------------------------------------------+
   void Initialize(
      const string symbol,
      const ENUM_TIMEFRAMES timeframe)
     {
      m_symbol    = symbol;
      m_timeframe = timeframe;

      m_bias = MARKET_BIAS_NEUTRAL;

      m_lastSwingCount = 0;

      ArrayResize(
         m_points,
         0
      );
     }


   //+------------------------------------------------------------------+
   //| Update structure                                                |
   //+------------------------------------------------------------------+
   bool Update(
      CSwingDetector &detector)
     {
      int swingCount =
         detector.GetSwingCount();

      if(swingCount <= 0)
         return false;


      // ---------------------------------------------------------------
      // Nothing new.
      // ---------------------------------------------------------------

      if(swingCount == m_lastSwingCount)
         return false;


      bool changed = false;


      // ---------------------------------------------------------------
      // Process all swings.
      // ---------------------------------------------------------------

      for(int i = m_lastSwingCount;
          i < swingCount;
          i++)
        {
         SwingPoint swing;

         if(!detector.GetSwing(
               i,
               swing))
            continue;


         if(ProcessSwing(
               swing))
            {
             changed = true;
            }
        }


      m_lastSwingCount =
         swingCount;


      // ---------------------------------------------------------------
      // Recalculate market bias.
      // ---------------------------------------------------------------

      UpdateBias();


      return changed;
     }


   //+------------------------------------------------------------------+
   //| Get structure count                                             |
   //+------------------------------------------------------------------+
   int GetStructureCount(void) const
     {
      return ArraySize(
         m_points
      );
     }


   //+------------------------------------------------------------------+
   //| Get structure point                                             |
   //+------------------------------------------------------------------+
   bool GetStructure(
      const int index,
      StructurePoint &point) const
     {
      int count =
         ArraySize(
            m_points
         );

      if(index < 0 ||
         index >= count)
         return false;


      point =
         m_points[index];

      return true;
     }


   //+------------------------------------------------------------------+
   //| Get last structure point                                        |
   //+------------------------------------------------------------------+
   bool GetLastStructure(
      StructurePoint &point) const
     {
      int count =
         ArraySize(
            m_points
         );

      if(count <= 0)
         return false;


      point =
         m_points[count - 1];

      return true;
     }


   //+------------------------------------------------------------------+
   //| Get last HH                                                     |
   //+------------------------------------------------------------------+
   bool GetLastHH(
      StructurePoint &point) const
     {
      return GetLastOfType(
         STRUCTURE_HH,
         point
      );
     }


   //+------------------------------------------------------------------+
   //| Get last HL                                                     |
   //+------------------------------------------------------------------+
   bool GetLastHL(
      StructurePoint &point) const
     {
      return GetLastOfType(
         STRUCTURE_HL,
         point
      );
     }


   //+------------------------------------------------------------------+
   //| Get last LH                                                     |
   //+------------------------------------------------------------------+
   bool GetLastLH(
      StructurePoint &point) const
     {
      return GetLastOfType(
         STRUCTURE_LH,
         point
      );
     }


   //+------------------------------------------------------------------+
   //| Get last LL                                                     |
   //+------------------------------------------------------------------+
   bool GetLastLL(
      StructurePoint &point) const
     {
      return GetLastOfType(
         STRUCTURE_LL,
         point
      );
     }


   //+------------------------------------------------------------------+
   //| Get market bias                                                 |
   //+------------------------------------------------------------------+
   EMarketBias GetBias(void) const
     {
      return m_bias;
     }


   //+------------------------------------------------------------------+
   //| Is bullish                                                      |
   //+------------------------------------------------------------------+
   bool IsBullish(void) const
     {
      return m_bias ==
             MARKET_BIAS_BULLISH;
     }


   //+------------------------------------------------------------------+
   //| Is bearish                                                      |
   //+------------------------------------------------------------------+
   bool IsBearish(void) const
     {
      return m_bias ==
             MARKET_BIAS_BEARISH;
     }


   //+------------------------------------------------------------------+
   //| Is neutral                                                      |
   //+------------------------------------------------------------------+
   bool IsNeutral(void) const
     {
      return m_bias ==
             MARKET_BIAS_NEUTRAL;
     }


   //+------------------------------------------------------------------+
   //| Clear structure                                                 |
   //+------------------------------------------------------------------+
   void Clear(void)
     {
      ArrayResize(
         m_points,
         0
      );

      m_bias =
         MARKET_BIAS_NEUTRAL;

      m_lastSwingCount = 0;
     }


   //+------------------------------------------------------------------+
   //| Structure type to string                                        |
   //+------------------------------------------------------------------+
   string StructureTypeToString(
      const EStructureType type) const
     {
      switch(type)
        {
         case STRUCTURE_HH:
            return "HH";

         case STRUCTURE_HL:
            return "HL";

         case STRUCTURE_LH:
            return "LH";

         case STRUCTURE_LL:
            return "LL";

         default:
            return "NONE";
        }
     }


   //+------------------------------------------------------------------+
   //| Bias to string                                                  |
   //+------------------------------------------------------------------+
   string BiasToString(
      const EMarketBias bias) const
     {
      switch(bias)
        {
         case MARKET_BIAS_BULLISH:
            return "BULLISH";

         case MARKET_BIAS_BEARISH:
            return "BEARISH";

         default:
            return "NEUTRAL";
        }
     }


private:


   //+------------------------------------------------------------------+
   //| Process swing                                                   |
   //+------------------------------------------------------------------+
   bool ProcessSwing(
      const SwingPoint &swing)
     {
      int count =
         ArraySize(
            m_points
         );


      // ---------------------------------------------------------------
      // First swing.
      //
      // There is nothing to compare against yet.
      // We don't assign HH/HL/LH/LL.
      // ---------------------------------------------------------------

      if(count == 0)
        {
         return AddStructurePoint(
            swing,
            STRUCTURE_NONE
         );
        }


      // ---------------------------------------------------------------
      // Find previous swing of the SAME TYPE.
      //
      // HIGH compares against previous HIGH.
      // LOW compares against previous LOW.
      // ---------------------------------------------------------------

      StructurePoint previousSameType;

      if(!GetPreviousSameType(
            swing,
            previousSameType))
         {
         return AddStructurePoint(
            swing,
            STRUCTURE_NONE
         );
        }


      EStructureType structureType =
         STRUCTURE_NONE;


      // ---------------------------------------------------------------
      // HIGH classification
      // ---------------------------------------------------------------

      if(swing.type ==
         SWING_TYPE_HIGH)
        {
         if(swing.price >
            previousSameType.price)
           {
            structureType =
               STRUCTURE_HH;
           }
         else
           {
            structureType =
               STRUCTURE_LH;
           }
        }


      // ---------------------------------------------------------------
      // LOW classification
      // ---------------------------------------------------------------

      else
      if(swing.type ==
         SWING_TYPE_LOW)
        {
         if(swing.price >
            previousSameType.price)
           {
            structureType =
               STRUCTURE_HL;
           }
         else
           {
            structureType =
               STRUCTURE_LL;
           }
        }


      return AddStructurePoint(
         swing,
         structureType
      );
     }


   //+------------------------------------------------------------------+
   //| Find previous same-type swing                                   |
   //+------------------------------------------------------------------+
   bool GetPreviousSameType(
      const SwingPoint &swing,
      StructurePoint &result) const
     {
      int count =
         ArraySize(
            m_points
         );


      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_points[i].swingType ==
            swing.type)
           {
            result =
               m_points[i];

            return true;
           }
        }


      return false;
     }


   //+------------------------------------------------------------------+
   //| Add structure point                                              |
   //+------------------------------------------------------------------+
   bool AddStructurePoint(
      const SwingPoint &swing,
      const EStructureType structureType)
     {
      int count =
         ArraySize(
            m_points
         );


      // ---------------------------------------------------------------
      // Avoid duplicate time/type.
      // ---------------------------------------------------------------

      for(int i = 0;
          i < count;
          i++)
        {
         if(m_points[i].time ==
            swing.time &&
            m_points[i].swingType ==
            swing.type)
            return false;
        }


      int index =
         count;


      ArrayResize(
         m_points,
         index + 1
      );


      m_points[index].symbol =
         swing.symbol;

      m_points[index].timeframe =
         swing.timeframe;

      m_points[index].time =
         swing.time;

      m_points[index].shift =
         swing.shift;

      m_points[index].price =
         swing.price;

      m_points[index].swingType =
         swing.type;

      m_points[index].structureType =
         structureType;

      m_points[index].confirmed =
         swing.confirmed;


      return true;
     }


   //+------------------------------------------------------------------+
   //| Find last structure type                                        |
   //+------------------------------------------------------------------+
   bool GetLastOfType(
      const EStructureType type,
      StructurePoint &point) const
     {
      int count =
         ArraySize(
            m_points
         );


      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_points[i].structureType ==
            type)
           {
            point =
               m_points[i];

            return true;
           }
        }


      return false;
     }


   //+------------------------------------------------------------------+
   //| Update market bias                                              |
   //+------------------------------------------------------------------+
   void UpdateBias(void)
     {
      bool hasHH =
         HasStructureType(
            STRUCTURE_HH
         );

      bool hasHL =
         HasStructureType(
            STRUCTURE_HL
         );

      bool hasLH =
         HasStructureType(
            STRUCTURE_LH
         );

      bool hasLL =
         HasStructureType(
            STRUCTURE_LL
         );


      // ---------------------------------------------------------------
      // Bullish structure:
      //
      // HH + HL
      // ---------------------------------------------------------------

      if(hasHH && hasHL &&
         !hasLL)
        {
         m_bias =
            MARKET_BIAS_BULLISH;

         return;
        }


      // ---------------------------------------------------------------
      // Bearish structure:
      //
      // LH + LL
      // ---------------------------------------------------------------

      if(hasLH && hasLL &&
         !hasHH)
        {
         m_bias =
            MARKET_BIAS_BEARISH;

         return;
        }


      // ---------------------------------------------------------------
      // If both structures exist, determine which one is most recent.
      // ---------------------------------------------------------------

      int bullishIndex =
         GetLatestBullishIndex();

      int bearishIndex =
         GetLatestBearishIndex();


      if(bullishIndex >
         bearishIndex)
        {
         m_bias =
            MARKET_BIAS_BULLISH;

         return;
        }


      if(bearishIndex >
         bullishIndex)
        {
         m_bias =
            MARKET_BIAS_BEARISH;

         return;
        }


      m_bias =
         MARKET_BIAS_NEUTRAL;
     }


   //+------------------------------------------------------------------+
   //| Has structure type                                              |
   //+------------------------------------------------------------------+
   bool HasStructureType(
      const EStructureType type) const
     {
      int count =
         ArraySize(
            m_points
         );


      for(int i = 0;
          i < count;
          i++)
        {
         if(m_points[i].structureType ==
            type)
            return true;
        }


      return false;
     }


   //+------------------------------------------------------------------+
   //| Latest bullish structure index                                  |
   //+------------------------------------------------------------------+
   int GetLatestBullishIndex(void) const
     {
      int count =
         ArraySize(
            m_points
         );


      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_points[i].structureType ==
               STRUCTURE_HH ||
            m_points[i].structureType ==
               STRUCTURE_HL)
           {
            return i;
           }
        }


      return -1;
     }


   //+------------------------------------------------------------------+
   //| Latest bearish structure index                                  |
   //+------------------------------------------------------------------+
   int GetLatestBearishIndex(void) const
     {
      int count =
         ArraySize(
            m_points
         );


      for(int i = count - 1;
          i >= 0;
          i--)
        {
         if(m_points[i].structureType ==
               STRUCTURE_LH ||
            m_points[i].structureType ==
               STRUCTURE_LL)
           {
            return i;
           }
        }


      return -1;
     }
  };

#endif // SMARTMONEYEA_MARKETSTRUCTURE_MQH
