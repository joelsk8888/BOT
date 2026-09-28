#ifndef SMARTMONEYEA_CONFIG_MQH
#define SMARTMONEYEA_CONFIG_MQH

//+------------------------------------------------------------------+
//| SmartMoneyEA - Configuration                                     |
//+------------------------------------------------------------------+

input group "===== GENERAL ====="

input string EA_Name = "SmartMoneyEA";
input long Magic_Number = 20260718;
input bool Enable_Auto_Settings = false;


//+------------------------------------------------------------------+
//| SYMBOL / EXECUTION                                               |
//+------------------------------------------------------------------+

input group "===== SYMBOL / EXECUTION ====="

input bool Restrict_To_XAUUSD = false;
input int Maximum_Open_Trades = 1;
input int Maximum_Slippage_Points = 30;


//+------------------------------------------------------------------+
//| TIMEFRAME HIERARCHY                                              |
//+------------------------------------------------------------------+

input group "===== TIMEFRAME HIERARCHY ====="

input ENUM_TIMEFRAMES Trend_Timeframe_H4 = PERIOD_H4;
input ENUM_TIMEFRAMES Trend_Timeframe_H1 = PERIOD_H1;
input ENUM_TIMEFRAMES Liquidity_Timeframe_M30 = PERIOD_M30;
input ENUM_TIMEFRAMES Refinement_Timeframe_M15 = PERIOD_M15;
input ENUM_TIMEFRAMES Engulfing_Timeframe_M5 = PERIOD_M5;
input ENUM_TIMEFRAMES CHOCH_Timeframe_M1 = PERIOD_M1;


//+------------------------------------------------------------------+
//| MARKET STRUCTURE / SWINGS                                        |
//+------------------------------------------------------------------+

input group "===== MARKET STRUCTURE ====="

input int Pivot_Strength = 2;

input int Minimum_Swing_Distance = 0;
input double Minimum_Swing_Distance_ATR = 0.20;

input bool Require_Confirmed_Swings = true;
input bool Allow_Same_Candle_Swings = false;


//+------------------------------------------------------------------+
//| TREND                                                            |
//+------------------------------------------------------------------+

input group "===== TREND ====="

input bool Use_H4_Bias = true;
input bool Use_H1_Confirmation = true;
input bool Require_H4_H1_Alignment = true;
input bool Use_Trend_Filter_For_Entry = true;


//+------------------------------------------------------------------+
//| LIQUIDITY                                                        |
//+------------------------------------------------------------------+

input group "===== LIQUIDITY ====="

input bool Use_Liquidity_Sweeps = true;
input bool Use_M30_Liquidity = true;
input bool Use_M15_Liquidity = true;
input bool Use_Daily_Liquidity = true;
input bool Use_Weekly_Liquidity = true;

input bool Use_Equal_Highs = true;
input bool Use_Equal_Lows = true;

input double Equal_High_Tolerance_ATR = 0.20;
input double Equal_Low_Tolerance_ATR = 0.20;

input int Liquidity_Lookback_Bars = 100;
input int Maximum_Liquidity_Level_Age = 200;


//+------------------------------------------------------------------+
//| LIQUIDITY SWEEP                                                  |
//+------------------------------------------------------------------+

input group "===== LIQUIDITY SWEEP ====="

input bool Require_Liquidity_Sweep = true;
input bool Require_Sweep_Close_Back_Inside = true;

input double Minimum_Sweep_Distance_ATR = 0.05;
input double Maximum_Sweep_Distance_ATR = 1.50;

input int Maximum_Sweep_Confirmation_Bars = 3;


//+------------------------------------------------------------------+
//| CHOCH                                                            |
//+------------------------------------------------------------------+

input group "===== CHOCH ====="

input bool Use_CHOCH = true;
input bool Require_CHOCH = true;
input bool CHOCH_Close_Required = true;

input int CHOCH_Lookback_Bars = 50;

input double Minimum_CHOCH_Displacement_ATR = 0.20;

input int Maximum_Bars_After_Sweep_For_CHOCH = 10;


//+------------------------------------------------------------------+
//| M5 ENGULFING                                                     |
//+------------------------------------------------------------------+

input group "===== M5 ENGULFING ====="

input bool Use_Engulfing_Confirmation = true;
input bool Require_Engulfing = false;

input bool Engulfing_Must_Consume_Previous_Candle = true;
input bool Engulfing_Close_In_Direction = true;

input double Minimum_Engulfing_Body_ATR = 0.10;
input double Minimum_Engulfing_Body_Ratio = 0.60;

input int Maximum_Bars_After_CHOCH_For_Engulfing = 5;


//+------------------------------------------------------------------+
//| FAIR VALUE GAP                                                   |
//+------------------------------------------------------------------+

input group "===== FAIR VALUE GAP ====="

input bool Use_FVG = true;
input bool Require_FVG = false;

input bool Require_FVG_Mitigation = true;
input bool Use_FVG_As_Entry_Zone = true;

input double Minimum_FVG_Size_ATR = 0.30;
input double Maximum_FVG_Size_ATR = 3.00;
input double Maximum_FVG_Distance_ATR = 2.00;

input int Maximum_FVG_Age = 10;

input bool Require_FVG_Direction_Alignment = true;
input bool Ignore_Fully_Filled_FVG = true;


//+------------------------------------------------------------------+
//| DISPLACEMENT                                                     |
//+------------------------------------------------------------------+

input group "===== DISPLACEMENT ====="

input bool Use_Displacement_Filter = true;

input double Minimum_Displacement_ATR = 0.50;
input double Strong_Displacement_ATR = 1.00;

input double Minimum_Displacement_Body_Ratio = 0.60;

input bool Require_Displacement_For_CHOCH = false;


//+------------------------------------------------------------------+
//| PREMIUM / DISCOUNT                                               |
//+------------------------------------------------------------------+

input group "===== PREMIUM / DISCOUNT ====="

input bool Use_Premium_Discount_Filter = true;
input bool Require_Premium_Discount_For_Entry = false;

input double Premium_Level = 0.50;
input double Discount_Level = 0.50;


//+------------------------------------------------------------------+
//| ORDER BLOCKS                                                     |
//+------------------------------------------------------------------+

input group "===== ORDER BLOCKS ====="

input bool Use_Order_Blocks = false;
input bool Require_Order_Block = false;

input int Order_Block_Lookback_Bars = 50;
input double Maximum_Order_Block_Distance_ATR = 2.00;


//+------------------------------------------------------------------+
//| CONFIRMATION SCORE                                               |
//+------------------------------------------------------------------+

input group "===== CONFIRMATION SCORE ====="

input bool Use_Confirmation_Score = true;

input int Minimum_Score = 70;

input int Score_H4_Trend = 15;
input int Score_H1_Trend = 10;
input int Score_Liquidity_Sweep = 20;
input int Score_M15_Zone = 10;
input int Score_CHOCH = 20;
input int Score_Engulfing = 10;
input int Score_FVG = 10;
input int Score_Displacement = 5;


//+------------------------------------------------------------------+
//| ENTRY                                                            |
//+------------------------------------------------------------------+

input group "===== ENTRY ====="

input bool Enable_Trading = false;

input bool One_Entry_Per_Signal = true;
input bool Require_All_Mandatory_Confirmations = false;

input bool Allow_Market_Entry = true;
input bool Allow_Limit_Entry = false;

input int Entry_Mode = 0;

input int Maximum_Entry_Delay_Bars = 3;


//+------------------------------------------------------------------+
//| TAKE PROFIT                                                      |
//+------------------------------------------------------------------+

input group "===== TAKE PROFIT ====="

input bool Use_Take_Profit = true;

input int TP_Mode = 1;

input double Fixed_Take_Profit_Points = 300.0;
input double Take_Profit_ATR_Multiplier = 1.50;

input bool Use_Next_Liquidity_As_Target = true;

input bool Require_Minimum_Risk_Reward = false;
input double Minimum_Risk_Reward = 1.50;


//+------------------------------------------------------------------+
//| STOP LOSS                                                        |
//+------------------------------------------------------------------+

input group "===== STOP LOSS ====="

input bool Use_Stop_Loss = false;

input int Stop_Loss_Mode = 0;

input double Stop_Loss_ATR_Multiplier = 1.50;
input double Fixed_Stop_Loss_Points = 500.0;

input double Structural_Stop_Buffer_ATR = 0.10;


//+------------------------------------------------------------------+
//| EMERGENCY PROTECTION                                             |
//+------------------------------------------------------------------+

input group "===== EMERGENCY PROTECTION ====="

input bool Use_Emergency_Stop = true;

input double Maximum_Adverse_Move_ATR = 3.00;
input double Maximum_Position_Loss_Percent = 2.00;


//+------------------------------------------------------------------+
//| RISK MANAGEMENT                                                  |
//+------------------------------------------------------------------+

input group "===== RISK MANAGEMENT ====="

input bool Enable_Risk_Management = true;

input double Risk_Per_Trade_Percent = 0.50;

input double Maximum_Daily_Loss_Percent = 2.00;
input double Maximum_Account_Drawdown_Percent = 10.00;

input int Maximum_Consecutive_Losses = 3;

input bool Stop_Trading_After_Daily_Loss = true;
input bool Stop_Trading_After_Drawdown = true;
input bool Stop_Trading_After_Consecutive_Losses = true;


//+------------------------------------------------------------------+
//| POSITION SIZING                                                  |
//+------------------------------------------------------------------+

input group "===== POSITION SIZING ====="

input bool Use_Risk_Based_Lot_Size = true;

input double Fixed_Lot_Size = 0.01;
input double Minimum_Lot_Size = 0.01;
input double Maximum_Lot_Size = 10.00;
input double Lot_Size_Step = 0.01;


//+------------------------------------------------------------------+
//| PARTIAL CLOSE                                                    |
//+------------------------------------------------------------------+

input group "===== PARTIAL CLOSE ====="

input bool Enable_Partial_Close = true;

input double Partial_1_Trigger_R = 1.00;
input double Partial_1_Percent = 30.0;

input double Partial_2_Trigger_R = 2.00;
input double Partial_2_Percent = 30.0;

input bool Move_To_BreakEven_After_Partial = true;


//+------------------------------------------------------------------+
//| BREAK EVEN                                                       |
//+------------------------------------------------------------------+

input group "===== BREAK EVEN ====="

input bool Use_Break_Even = true;

input double Break_Even_Trigger_R = 1.00;
input double Break_Even_Buffer_Points = 10.0;


//+------------------------------------------------------------------+
//| TRAILING                                                         |
//+------------------------------------------------------------------+

input group "===== TRAILING ====="

input bool Use_Trailing_Structure = false;
input bool Use_ATR_Trailing = false;

input double Trailing_ATR_Multiplier = 1.50;

input int Trailing_Swing_Lookback = 5;

input double Trailing_Structure_Buffer_ATR = 0.10;


//+------------------------------------------------------------------+
//| SPREAD FILTER                                                    |
//+------------------------------------------------------------------+

input group "===== SPREAD FILTER ====="

input bool Enable_Spread_Filter = true;

input double Maximum_Spread_Points = 30.0;
input double Maximum_Spread_ATR_Ratio = 0.10;


//+------------------------------------------------------------------+
//| SESSION FILTER                                                   |
//+------------------------------------------------------------------+

input group "===== SESSION FILTER ====="

input bool Enable_Session_Filter = true;

input bool Allow_London_Session = true;
input bool Allow_New_York_Session = true;
input bool Allow_Asian_Session = false;

input int Session_Mode = 3;


//+------------------------------------------------------------------+
//| NEWS FILTER                                                      |
//+------------------------------------------------------------------+

input group "===== NEWS FILTER ====="

input bool Enable_News_Filter = false;

input int News_Block_Before_Minutes = 30;
input int News_Block_After_Minutes = 30;

input bool Block_High_Impact_News = true;
input bool Block_Medium_Impact_News = false;


//+------------------------------------------------------------------+
//| TRADING HOURS                                                    |
//+------------------------------------------------------------------+

input group "===== TRADING HOURS ====="

input bool Use_Trading_Hours = false;

input int Trading_Start_Hour = 7;
input int Trading_Start_Minute = 0;

input int Trading_End_Hour = 20;
input int Trading_End_Minute = 0;


//+------------------------------------------------------------------+
//| BACKTEST / RESEARCH                                              |
//+------------------------------------------------------------------+

input group "===== BACKTEST / RESEARCH ====="

input bool Enable_Research_Mode = true;

input bool Save_CSV = true;
input bool Enable_Trade_Statistics = true;

input bool Record_Rejected_Setups = true;
input bool Record_Signal_Score = true;
input bool Record_Liquidity_Data = true;
input bool Record_CHOCH_Data = true;
input bool Record_FVG_Data = true;
input bool Record_Entry_Data = true;
input bool Record_Exit_Data = true;


//+------------------------------------------------------------------+
//| DEBUG                                                            |
//+------------------------------------------------------------------+

input group "===== DEBUG ====="

input bool Enable_Debug_Logs = true;
input bool Enable_Trade_Logger = true;
input bool Enable_CSV_Logging = true;

input bool Debug_Structure = true;
input bool Debug_Liquidity = false;
input bool Debug_CHOCH = false;
input bool Debug_FVG = false;
input bool Debug_Entry = false;
input bool Debug_Risk = false;


//+------------------------------------------------------------------+
//| VISUALIZATION                                                    |
//+------------------------------------------------------------------+

input group "===== VISUALIZATION ====="

input bool Enable_Chart_Objects = true;

input bool Draw_Swing_Points = true;

input bool Draw_Liquidity_Zones = true;
input bool Draw_CHOCH = true;
input bool Draw_FVG = true;
input bool Draw_Order_Blocks = true;

input bool Draw_Entry_Levels = true;
input bool Draw_Trade_Targets = true;


//+------------------------------------------------------------------+

#endif // SMARTMONEYEA_CONFIG_MQH
