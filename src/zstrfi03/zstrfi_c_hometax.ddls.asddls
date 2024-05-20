@EndUserText.label: '[FI] 세금계산서'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZSTRFI_C_HOMETAX
  provider contract transactional_query
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
