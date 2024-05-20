@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회 - Status Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI12_V_STATUS 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZSTRDO_DOSTATE')
  
  {
      @UI.selectionField: [{exclude: true}]
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
//      @Semantics.language: true
      @UI.hidden: true
  key language,
      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: '입금처리결과코드'
      value_low,
      @Consumption.valueHelpDefault.display: true
      @EndUserText.label: '입금처리결과'
      @Semantics.text: true
      text      
}
