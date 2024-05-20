@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_CNT 
 as select from ZSTRFI_I_NTSJE_COUNT
{
  key HTApprvNo,
    
      sum(cnt) as cnt
}group by HTApprvNo
