@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZSTRFI_I_HOMETAX
  as select from zstrtfi0030
{
  key id                    as ID,
      ntsinputdate          as HTInputDate,
      ntsapprvno            as HTApprvNo,
      ntssupplierno         as HTSupplierNo,
      @Semantics.amount.currencyCode: 'Currency'
      ntsnetamount          as HTSupplyAmount,
      ntssupplier           as HTSupplier,
      @Semantics.amount.currencyCode: 'Currency'
      ntstaxamount          as HTTaxAmount,
      @Semantics.amount.currencyCode: 'Currency'
      ntstotalamount        as HTTotalAmount,
      currency              as Currency,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy
}
