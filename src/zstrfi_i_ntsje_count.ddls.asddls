@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 세금계산서 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_NTSJE_COUNT 
  as select distinct from ZSTRFI_I_NTSJE_SOURCE 
{
    key HTApprvNo,
  
    key CompanyCode,
  
    key FiscalYear,
  
    key AccountingDocument,
        
        case
          when AccountingDocument is null
            then
              cast(0 as abap.int4)
            else
              cast(1 as abap.int4)
        end as cnt
}


