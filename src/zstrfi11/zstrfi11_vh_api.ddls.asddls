@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 지급 이체 요청 - API전송 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI11_VH_API
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZSTRFI11_DOAPI')
{
      @UI.selectionField: [{exclude: true}]
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
      @Semantics.language: true
  key language,
      @EndUserText.label: '지급요청결과코드'
      value_low,
      @EndUserText.label: '지급이체요청결과'
      @Semantics.text: true
      text      
}
