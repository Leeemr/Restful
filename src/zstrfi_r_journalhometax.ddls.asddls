@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
define root view entity ZSTRFI_R_JOURNALHOMETAX as select from ZSTRFI_I_JOURNALHOMETAX
{
  key HTInputDate,
  key HTApprvNo,
  key HTSupplierNo,
  key HTSupplyAmount,
  HTSupplier,
  HTTaxAmount,
  HTTotalAmount,
  Currency,
  CompanyCode,
  BusinessPlace,
  FiscalYear,
  AcctDoc,
  AcctDocType,
  DocumentDate,
  PostingDate,
  TransactionCurr,
  TaxAmount,
  TotalAmount,
  SupplyAmount,
  Supplier,
  SupplierNM,
  SupplierTaxNum2,
  AmountDifference
}
