@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_JENTS_COUNT 
  as select distinct from ZSTRFI_I_JENTS_SOURCE
{
  key CompanyCode,
  
  key FiscalYear,
  
  key AccountingDocument,
  
  key HTApprvNo,
      
      case
          when HTApprvNo is null
            then
              cast(0 as abap.int4)
            else
              cast(1 as abap.int4)
      end as cnt
}
