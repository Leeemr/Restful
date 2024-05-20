@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
define abstract entity ZSTRFI_A_EXP_ERR_02
{
  HTApprvNo      : abap.string;
  HTInputDate    : abap.string;
  HTSupplierNo   : abap.string;
  HTSupplier     : abap.string;
  HTTotalAmount  : abap.string;
  HTSupplyAmount : abap.string;
  HTTaxAmount    : abap.string;
  Currency       : abap.string;
  ErrMsg         : abap.string;
  UpdateKey      : abap.string;
}
