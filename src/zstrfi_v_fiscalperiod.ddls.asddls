@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] Fiscal Period Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_V_FISCALPERIOD
  as select distinct from I_FiscalYearPeriodForCmpnyCode
  
{
      @Consumption.valueHelpDefault.display: true
  key FiscalPeriod,

      @Consumption.valueHelpDefault.display: true
      IsSpecialPeriod
}
