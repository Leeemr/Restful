@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입출금 거래 내역 조회 - Bank Key Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI13_V_BANKKEY 
as select distinct from ZSTRFI13_V_BANK

{
     
    @Consumption.valueHelpDefault.display: true 
    @EndUserText.label: '주거래은행키'    
    key BankInternalID
    
}

group by

   BankInternalID
 
