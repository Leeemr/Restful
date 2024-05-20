@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 지급이체요청 - 예금자조회 Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTRFI11_VH_MATCH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZSTRIF_DOMATCH')
{
      @UI.selectionField: [{exclude: true}]
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
      @Semantics.language: true
  key language,
      @EndUserText.label: '처리결과코드'
      value_low,
      @EndUserText.label: '처리결과'
      @Semantics.text: true
      text
}
