@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZSTRFI_C_JOURNALHOMETAX
  as projection on ZSTRFI_R_HOMETAX
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
