#ifndef SMARTMONEYEA_LOGGER_MQH
#define SMARTMONEYEA_LOGGER_MQH

#include "Config.mqh"

//+------------------------------------------------------------------+
//| SmartMoneyEA - Logger                                            |
//+------------------------------------------------------------------+
//| Centralized logging system.                                      |
//|                                                                  |
//| Responsibilities:                                               |
//| - Terminal logs                                                  |
//| - Debug logs                                                     |
//| - Warning/error logs                                             |
//| - Trade/event logs                                               |
//| - Optional CSV research logging                                  |
//|                                                                  |
//| This module contains NO trading logic.                           |
//+------------------------------------------------------------------+

class CLogger
  {
public:

   //+------------------------------------------------------------------+
   //| Log levels                                                       |
   //+------------------------------------------------------------------+
   enum ELogLevel
     {
      LOG_INFO = 0,
      LOG_WARNING,
      LOG_ERROR,
      LOG_DEBUG,
      LOG_TRADE
     };


   //+------------------------------------------------------------------+
   //| Constructor                                                      |
   //+------------------------------------------------------------------+
   CLogger(void)
     {
     }


   //+------------------------------------------------------------------+
   //| Destructor                                                       |
   //+------------------------------------------------------------------+
   ~CLogger(void)
     {
     }


   //+------------------------------------------------------------------+
   //| Informational message                                           |
   //+------------------------------------------------------------------+
   void Info(const string message,
             const string subsystem="GENERAL")
     {
      Log(LOG_INFO,message,subsystem);
     }


   //+------------------------------------------------------------------+
   //| Warning message                                                  |
   //+------------------------------------------------------------------+
   void Warning(const string message,
                const string subsystem="GENERAL")
     {
      Log(LOG_WARNING,message,subsystem);
     }


   //+------------------------------------------------------------------+
   //| Error message                                                    |
   //+------------------------------------------------------------------+
   void Error(const string message,
              const string subsystem="GENERAL")
     {
      Log(LOG_ERROR,message,subsystem);
     }


   //+------------------------------------------------------------------+
   //| Debug message                                                    |
   //+------------------------------------------------------------------+
   void Debug(const string message,
              const string subsystem="GENERAL")
     {
      Log(LOG_DEBUG,message,subsystem);
     }


   //+------------------------------------------------------------------+
   //| Trade/event message                                              |
   //+------------------------------------------------------------------+
   void Trade(const string message,
              const string subsystem="TRADE",
              const string direction="",
              const double price=0.0,
              const int score=0,
              const string setup="",
              const string result="")
     {
      if(!Enable_Trade_Logger)
         return;

      string tradeMessage = message;

      if(StringLen(direction) > 0 ||
         price > 0.0 ||
         score > 0 ||
         StringLen(setup) > 0 ||
         StringLen(result) > 0)
        {
         tradeMessage = StringFormat(
            "%s | dir=%s | price=%.5f | score=%d | setup=%s | result=%s",
            message,
            direction,
            price,
            score,
            setup,
            result
         );
        }

      Log(LOG_TRADE,tradeMessage,subsystem);

      if(Enable_CSV_Logging && Enable_Research_Mode)
        {
         LogCsv(
            LOG_TRADE,
            "TRADE",
            direction,
            price,
            score,
            setup,
            result,
            subsystem
         );
        }
     }


   //+------------------------------------------------------------------+
   //| Check whether a log level is enabled                            |
   //+------------------------------------------------------------------+
   bool IsLevelEnabled(const ELogLevel level) const
     {
      switch(level)
        {
         case LOG_DEBUG:
            return Enable_Debug_Logs;

         case LOG_TRADE:
            return Enable_Trade_Logger;

         default:
            return true;
        }
     }


   //+------------------------------------------------------------------+
   //| Generic event logger                                             |
   //+------------------------------------------------------------------+
   void LogEvent(const ELogLevel level,
                 const string message,
                 const string subsystem="GENERAL")
     {
      Log(level,message,subsystem);
     }


   //+------------------------------------------------------------------+
   //| CSV event logger                                                 |
   //+------------------------------------------------------------------+
   void LogCsv(const ELogLevel level,
               const string event_type,
               const string direction="",
               const double price=0.0,
               const int score=0,
               const string setup="",
               const string result="",
               const string subsystem="GENERAL") const
     {
      if(!Enable_CSV_Logging || !Enable_Research_Mode)
         return;

      string fileName = "SmartMoneyEA_Events.csv";

      bool fileExists = FileIsExist(fileName);

      int handle = FileOpen(
         fileName,
         FILE_WRITE |
         FILE_READ |
         FILE_CSV |
         FILE_ANSI |
         FILE_SHARE_READ |
         FILE_SHARE_WRITE,
         ','
      );

      if(handle == INVALID_HANDLE)
        {
         Print(
            "[CLogger] Unable to open CSV file: ",
            fileName,
            " | error=",
            GetLastError()
         );

         return;
        }


      //--- Create CSV header if the file is new
      if(!fileExists)
        {
         FileWrite(
            handle,
            "timestamp",
            "symbol",
            "level",
            "subsystem",
            "event_type",
            "direction",
            "price",
            "score",
            "setup",
            "result"
         );
        }


      //--- Prepare data
      string timestamp = BuildTimestamp();
      string symbolName = _Symbol;
      string eventLevel = LevelToString(level);

      string safeDirection = direction;
      string safeSetup = setup;
      string safeResult = result;
      string safeSubsystem = NormalizeSubsystem(subsystem);


      if(StringLen(safeDirection) == 0)
         safeDirection = "UNKNOWN";

      if(StringLen(safeSetup) == 0)
         safeSetup = "-";

      if(StringLen(safeResult) == 0)
         safeResult = "-";


      //--- Move to end of file
      FileSeek(handle,0,SEEK_END);


      //--- Write event
      FileWrite(
         handle,
         timestamp,
         symbolName,
         eventLevel,
         safeSubsystem,
         event_type,
         safeDirection,
         price,
         score,
         safeSetup,
         safeResult
      );


      FileClose(handle);
     }


private:

   //+------------------------------------------------------------------+
   //| Internal terminal logger                                        |
   //+------------------------------------------------------------------+
   void Log(const ELogLevel level,
            const string message,
            const string subsystem) const
     {
      if(!IsLevelEnabled(level))
         return;

      if(StringLen(message) == 0)
         return;

      string levelText = LevelToString(level);
      string normalizedSubsystem = NormalizeSubsystem(subsystem);

      string output =
         "[" +
         BuildTimestamp() +
         "] [" +
         levelText +
         "] [" +
         normalizedSubsystem +
         "] " +
         message;

      Print(output);
     }


   //+------------------------------------------------------------------+
   //| Timestamp                                                        |
   //+------------------------------------------------------------------+
   string BuildTimestamp(void) const
     {
      return TimeToString(
         TimeCurrent(),
         TIME_DATE | TIME_SECONDS
      );
     }


   //+------------------------------------------------------------------+
   //| Normalize subsystem name                                        |
   //+------------------------------------------------------------------+
   string NormalizeSubsystem(const string subsystem) const
     {
      string normalized = subsystem;

      //--- MQL5 trimming functions modify the string itself
      StringTrimLeft(normalized);
      StringTrimRight(normalized);

      if(StringLen(normalized) == 0)
         return "GENERAL";

      StringToUpper(normalized);


      if(normalized == "STRUCTURE" ||
         normalized == "STRUCT")
         return "STRUCTURE";


      if(normalized == "LIQUIDITY")
         return "LIQUIDITY";


      if(normalized == "CHOCH")
         return "CHOCH";


      if(normalized == "FVG")
         return "FVG";


      if(normalized == "ORDERBLOCK" ||
         normalized == "ORDER_BLOCK" ||
         normalized == "OB")
         return "ORDER_BLOCK";


      if(normalized == "ENTRY")
         return "ENTRY";


      if(normalized == "RISK")
         return "RISK";


      if(normalized == "TRADE")
         return "TRADE";


      if(normalized == "SESSION")
         return "SESSION";


      if(normalized == "SPREAD")
         return "SPREAD";


      if(normalized == "FILTER")
         return "FILTER";


      if(normalized == "GENERAL" ||
         normalized == "GENERIC")
         return "GENERAL";


      return normalized;
     }


   //+------------------------------------------------------------------+
   //| Convert log level to text                                       |
   //+------------------------------------------------------------------+
   string LevelToString(const ELogLevel level) const
     {
      switch(level)
        {
         case LOG_INFO:
            return "INFO";

         case LOG_WARNING:
            return "WARNING";

         case LOG_ERROR:
            return "ERROR";

         case LOG_DEBUG:
            return "DEBUG";

         case LOG_TRADE:
            return "TRADE";

         default:
            return "INFO";
        }
     }
  };

#endif // SMARTMONEYEA_LOGGER_MQH
