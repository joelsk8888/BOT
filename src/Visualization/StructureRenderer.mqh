#ifndef SMARTMONEYEA_STRUCTURE_RENDERER_MQH
#define SMARTMONEYEA_STRUCTURE_RENDERER_MQH

#include "../Core/Config.mqh"
#include "../Core/Utils.mqh"
#include "../Analysis/SwingDetector.mqh"

//+------------------------------------------------------------------+
//| SmartMoneyEA - Structure Renderer                                |
//+------------------------------------------------------------------+
//| Draws confirmed swing points on the chart.                       |
//|                                                                  |
//| This module ONLY renders data it is given. It performs no        |
//| detection or analysis of its own.                                 |
//+------------------------------------------------------------------+

class CStructureRenderer
  {
private:
   string m_prefix;

public:

   CStructureRenderer(void)
     {
      m_prefix = "SMEA_SWING_LINE_";
     }

   ~CStructureRenderer(void)
     {
     }

   int DrawAll(CSwingDetector &detector)
     {
      if(!Enable_Chart_Objects || !Draw_Swing_Points)
        {
         DeleteObjects();
         ChartRedraw(0);
         return 0;
        }

      int count = detector.GetSwingCount();

      Print("STRUCTURE RENDERER | swings=", count);

      if(count < 2)
         return 0;

      DeleteObjects();

      int drawn = 0;

      for(int i = 1; i < count; i++)
        {
         SwingPoint previous;
         SwingPoint current;

         if(!detector.GetSwing(i - 1, previous))
            continue;

         if(!detector.GetSwing(i, current))
            continue;

         string name =
            m_prefix +
            IntegerToString(i);

         if(!ObjectCreate(
               0,
               name,
               OBJ_TREND,
               0,
               previous.time,
               previous.price,
               current.time,
               current.price))
            {
             Print(
                "STRUCTURE RENDERER | ObjectCreate failed | ",
                name,
                " | error=",
                GetLastError()
             );

             continue;
            }

         ObjectSetInteger(
            0,
            name,
            OBJPROP_RAY_RIGHT,
            false
         );

         ObjectSetInteger(
            0,
            name,
            OBJPROP_RAY_LEFT,
            false
         );

         ObjectSetInteger(
            0,
            name,
            OBJPROP_WIDTH,
            2
         );

         ObjectSetInteger(
            0,
            name,
            OBJPROP_SELECTABLE,
            false
         );

         ObjectSetInteger(
            0,
            name,
            OBJPROP_HIDDEN,
            false
         );

         drawn++;
        }

      ChartRedraw(0);

      Print(
         "STRUCTURE RENDERER | lines drawn=",
         drawn
      );

      return drawn;
     }


   void Refresh(void)
     {
      ChartRedraw(0);
     }


   void DeleteAll(void)
     {
      DeleteObjects();
      ChartRedraw(0);
     }


private:

   void DeleteObjects(void)
     {
      int total = ObjectsTotal(0, -1, -1);

      for(int i = total - 1; i >= 0; i--)
        {
         string name = ObjectName(0, i, -1, -1);

         if(StringFind(name, m_prefix) == 0)
            ObjectDelete(0, name);
        }
     }
  };

#endif
