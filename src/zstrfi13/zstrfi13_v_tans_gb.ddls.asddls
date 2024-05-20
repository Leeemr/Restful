@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회 - 거래 구분 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI13_V_TANS_GB 
as select distinct from ZSTRFI13_I_LIST
{      
    @Consumption.valueHelpDefault.display: true 
    @EndUserText.label: '거래구분'    
    key TransactionGb,
    
    @EndUserText.label: '거래구분명'
    key TransactionGbName
}

group by
   TransactionGb,
   TransactionGbName
