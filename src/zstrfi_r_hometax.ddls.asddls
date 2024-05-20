@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
define root view entity ZSTRFI_R_HOMETAX
  as select from ZSTRFI_I_HOMETAX
{
  key ID,
      HTInputDate,
      HTApprvNo,
      HTSupplierNo,
      HTSupplyAmount,
      HTSupplier,
      HTTaxAmount,
      HTTotalAmount,
      Currency,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      LastChangedBy
}
