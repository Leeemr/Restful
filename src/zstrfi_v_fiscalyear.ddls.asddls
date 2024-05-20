@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] Fiscal Year Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
//@Search.searchable: true
define view entity ZSTRFI_V_FISCALYEAR
  as select from I_FiscalYearForCompanyCode
{
      @Consumption.valueHelpDefault.display: false
  key CompanyCode,

      @Consumption.valueHelpDefault.display: true
      @Search : {
      defaultSearchElement: true,
      fuzzinessThreshold: 0.8
      }
  key FiscalYear
}
