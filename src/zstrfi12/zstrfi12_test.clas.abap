CLASS zstrfi12_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSTRFI12_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : it_test TYPE TABLE OF zstrfi13_alist.
    it_test = VALUE #(
    (
    bukrs = '1000'
    belnr = ''
    gjahr = ''
*    kunnr = ''
*    knunrname  = ''
*    blart  = ''
    caccnt = '11009000'
    caccntt_dt = '가수금' "차변내역
*    akont = '1131235'
*    akont_dt = '외상매출금'
    seq_no = '1'
    ubnkl = '003'   "은행코드
    ubknt = '33711726904019'
    jukyo  = '테스트 데이터'
    in_bal = '1000.00'
    out_bal = '0.0'
    waers  = 'KRW'
    tran_key = '33711726904019KRW2024030413593929'
    tran_gb   = '1'
    tran_gb_nm = '입금'
    status   = 'R'
    trans_time = '133430'
    trans_date = '20240408'
    ) ).
    INSERT zstrfi13_alist FROM TABLE @it_test.

    SELECT * FROM zstrfi13_alist INTO TABLE @it_test.
    out->write( sy-dbcnt ).
*
*    DELETE FROM zstrfi12_alist.

  ENDMETHOD.
ENDCLASS.
