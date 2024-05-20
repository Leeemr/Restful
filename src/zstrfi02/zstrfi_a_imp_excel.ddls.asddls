@EndUserText.label: '[FI] 부가세 신고 - 세금계산서 기준 회계원장 대사'
define abstract entity ZSTRFI_A_IMP_EXCEL
{
  excel_file : abap.string;
  fr_col     : abap.char(2);
  to_col     : abap.char(2);
  fr_row     : abap.int2;

}
