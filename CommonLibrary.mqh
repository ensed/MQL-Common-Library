#property strict

#include <Common Library\Account\AccountBalanceCalcator\AccountBalanceCalculatorCurrent.mqh>
#include <Common Library\Filter\FilterByCountOfOpenOrders.mqh>
#include <Common Library\Filter\FilterByCountOfOpenOrdersAtCurrentBar.mqh>
#include <Common Library\Filter\FilterByTimeRange.mqh>
#include <Common Library\Helpers\VolumeNormalizer.mqh>
#include <Common Library\Indicators API\IndicatorAPIBase.mqh>
#include <Common Library\Modifiable Value Calculator\ModifiableValueCalculator.mqh>
#include <Common Library\Modifiable Value Calculator\ModifiableValueCalculatorFixed.mqh>
#include <Common Library\Modifiable Value Calculator\StopLossCalculatorFixed.mqh>
#include <Common Library\Modifiable Value Calculator\TakeProfitCalculatorByRatioFromStopLoss.mqh>
#include <Common Library\Modifiable Value Calculator\TakeProfitCalculatorFixed.mqh>
#include <Common Library\Orders Processor\EntryProcessorForMarketOrder.mqh>
#include <Common Library\Orders Processor\EntryProcessorForPendingOrder.mqh>
#include <Common Library\Orders Processor\ExitBuysAndSellsProcessor.mqh>
#include <Common Library\Orders Processor\ExitProcessorForOrderWithSpecifiedType.mqh>
#include <Common Library\Orders Processor\TrailingStopLossSimple.mqh>
#include <Common Library\Orders Source\HistoryOrders.mqh>
#include <Common Library\Orders Source\OpenOrders.mqh>
#include <Common Library\Signal Checker\SignalCheckerAlwaysTrue.mqh>
#include <Common Library\Signal Checker\SignalCheckerByFilter.mqh>
#include <Common Library\Volume Calculator\FixedVolumeCalculator.mqh>
#include <Common Library\Volume Calculator\VolumeCalculator.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorByLastCloseTrade.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorByLastOpenTrade.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorByPercentsOfFreeMargin.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorByRiskFromTradeStopLoss.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorWithDependenceFromBalance.mqh>
#include <Common Library\Volume Calculator\VolumeCalculatorWithNormalization.mqh>