#property strict

#include <Common Library\Account\AccountBalanceCalcator\AccountBalanceCalculatorCurrent.mqh>
#include <Common Library\Filter\FilterByCountOfOpenOrders.mqh>
#include <Common Library\Filter\FilterByCountOfOpenOrdersAtCurrentBar.mqh>
#include <Common Library\Filter\FilterByTimeRange.mqh>
#include <Common Library\Orders Processor\EntryProcessorForPendingOrder.mqh>
#include <Common Library\Orders Processor\ExitProcessorForOrderWithSpecifiedType.mqh>
#include <Common Library\Orders Source\OpenOrders.mqh>
#include <Common Library\Orders Source\HistoryOrders.mqh>
#include <Common Library\Signal Checker\SignalCheckerByFilter.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorByRiskFromTradeStopLoss.mqh>
#include <Common Library\Helpers\VolumeNormalizer.mqh>
#include <Common Library\Orders Processor\ExitBuysAndSellsProcessor.mqh>
#include <Common Library\Signal Checker\SignalCheckerAlwaysTrue.mqh>