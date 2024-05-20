@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입출금 거래 내역 조회 - Bank Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI13_V_BANK 
as select distinct from ZSTRFI13_R_LIST

{       
    @Consumption.valueHelpDefault.display: true
    @EndUserText.label: '주거래은행키'
    key BankInternalID,
    
//    @Consumption.valueHelpDefault.display: true
//    BankName 
    
    @Consumption.valueHelpDefault.display: true
    @EndUserText.label: '주거래은행계좌'    
    key BankAccount
    
}

group by

//    HouseBank,
//    HouseBankAccount  
   BankInternalID,
//   BankName 
   BankAccount
