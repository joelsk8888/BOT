#ifndef SMARTMONEYEA_MQH
#define SMARTMONEYEA_MQH

#include "../src/Core/Config.mqh"
#include "../src/Core/Logger.mqh"
#include "../src/Analysis/SwingDetector.mqh"
#include "../src/Analysis/MarketStructure.mqh"
#include "../src/Visualization/StructureRenderer.mqh"

//+------------------------------------------------------------------+
//| SmartMoneyEA - Main Controller                                   |
//+------------------------------------------------------------------+

class CSmartMoneyEA
  {
private:

   CLogger            m_logger;
   CSwingDetector     m_swingDetector;
   CMarketStructure   m_marketStructure;
   CStructureRenderer m_structureRenderer;

public:

   //+------------------------------------------------------------------+
   //| Constructor                                                       |
   //+------------------------------------------------------------------+
   CSmartMoneyEA(void)
     {
     }


   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
   ~CSmartMoneyEA(void)
     {
     }


   //+------------------------------------------------------------------+
   //| Initialize                                                       |
   //+------------------------------------------------------------------+
   bool Initialize(const string symbol,
                   const ENUM_TIMEFRAMES timeframe)
     {
      m_logger.Info(
         "SmartMoneyEA initialization started",
         "GENERAL"
      );


      //--- Initialize swing detector
      m_swingDetector.Initialize(
         symbol,
         timeframe
      );


      //--- Initialize market structure
      m_marketStructure.Initialize(
         symbol,
         timeframe
      );


      //--- Run the engine pipeline once so any history already present
      //--- on the chart (EA attached to an existing chart, Strategy
      //--- Tester warm-up, terminal restart, ...) is picked up immediately
      //--- instead of waiting for the next new bar.
      RunPipeline();


      m_logger.Info(
         StringFormat(
            "SmartMoneyEA initialized | swings=%d | structure=%d",
            m_swingDetector.GetSwingCount(),
            m_marketStructure.GetStructureCount()
         ),
         "GENERAL"
      );


      return true;
     }


   //+------------------------------------------------------------------+
   //| Update                                                           |
   //+------------------------------------------------------------------+
   void Update(void)
     {
      RunPipeline();
     }


   //+------------------------------------------------------------------+
   //| Shutdown                                                         |
   //+------------------------------------------------------------------+
   void Shutdown(void)
     {
      m_structureRenderer.DeleteAll();


      m_logger.Info(
         "SmartMoneyEA shutdown",
         "GENERAL"
      );
     }


private:

   //+------------------------------------------------------------------+
   //| Run the analysis pipeline for the current tick/bar.               |
   //|                                                                  |
   //| Order matters:                                                   |
   //|   1) SwingDetector produces raw pivots from price data.          |
   //|   2) MarketStructure classifies the new pivots into HH/HL/LH/LL. |
   //|   3) The renderer draws whatever the engines produced.           |
   //|                                                                  |
   //| Nothing here decides trend, liquidity, entries or risk yet -     |
   //| those engines are introduced in later phases.                    |
   //+------------------------------------------------------------------+
   void RunPipeline(void)
     {
      bool newSwing =
         m_swingDetector.Update();

      bool structureChanged =
         m_marketStructure.Update(
            m_swingDetector
         );

      if(!newSwing && !structureChanged)
         return;


      int drawn =
         m_structureRenderer.DrawAll(
            m_swingDetector
         );

      m_structureRenderer.Refresh();


      m_logger.Debug(
         StringFormat(
            "Structure updated | swings=%d | structure=%d | drawn=%d | bias=%s",
            m_swingDetector.GetSwingCount(),
            m_marketStructure.GetStructureCount(),
            drawn,
            m_marketStructure.BiasToString(m_marketStructure.GetBias())
         ),
         "STRUCTURE"
      );
     }
  };

#endif // SMARTMONEYEA_MQH
