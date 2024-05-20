@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JENTS_CNT 
  as select from ZSTRFI_I_JENTS_COUNT
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
      sum(cnt) as cnt
}group by CompanyCode, FiscalYear, AccountingDocument
