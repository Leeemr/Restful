@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 지급 이제 요청 - 헤더 BO'

define root view entity ZSTRFI11_R_HEADER
  as select from    zstrfi11_aheader as PaymentProposalPayment

    left outer join I_JournalEntry   as Journal on  PaymentProposalPayment.zbukr = Journal.CompanyCode
                                                and PaymentProposalPayment.gjahr = Journal.FiscalYear
                                                and PaymentProposalPayment.vblnr = Journal.AccountingDocument

  composition [0..*] of ZSTRFI11_R_ITEM        as _PaymentProposalItem

  // I_JournalEntry 를 상단의 join 으로 대체함. association 은 만약을 위해 남겨둠 (20240319)
  //  association [1..1] to I_JournalEntry         as _Journal              on  $projection.PayingCompanyCode = _Journal.CompanyCode
  //                                                                        and $projection.FiscalYear        = _Journal.FiscalYear
  //                                                                        and $projection.PaymentDocument   = _Journal.AccountingDocument

  association [0..1] to I_CompanyCode          as _CompanyCode          on  $projection.PayingCompanyCode = _CompanyCode.CompanyCode
  association [0..1] to I_Supplier             as _Supplier             on  $projection.Supplier = _Supplier.Supplier
  association [0..1] to I_Customer             as _Customer             on  $projection.Customer = _Customer.Customer
  association [0..1] to I_Currency             as _PaymentCurrency      on  $projection.PaymentCurrency = _PaymentCurrency.Currency
  association [0..1] to I_PaymentMethod        as _PaymentMethod        on  $projection.CompanyCodeCountry = _PaymentMethod.Country
                                                                        and $projection.PaymentMethod      = _PaymentMethod.PaymentMethod

  association [0..1] to I_CompanyCode          as _SendingCompanyCode   on  $projection.SendingCompanyCode = _SendingCompanyCode.CompanyCode

  association [0..1] to I_Country              as _BankCountry          on  $projection.BankCountry = _BankCountry.Country
  association [0..1] to I_Bank_2               as _Bank                 on  $projection.BankCountry    = _Bank.BankCountry
                                                                        and $projection.BankInternalID = _Bank.BankInternalID
  association [0..1] to I_Housebank            as _HouseBank            on  $projection.HouseBank         = _HouseBank.HouseBank
                                                                        and $projection.PayingCompanyCode = _HouseBank.CompanyCode

  association [0..1] to I_Bank_2               as _PayeeBank            on  $projection.PayeeBankCountry = _PayeeBank.BankCountry
                                                                        and $projection.PayeeBankKey     = _PayeeBank.BankInternalID
  association [0..1] to I_Country              as _PayeeBankCountry     on  $projection.PayeeBankCountry = _PayeeBankCountry.Country

  association [0..1] to I_FinancialAccountType as _FinancialAccountType on  $projection.FinancialAccountType = _FinancialAccountType.FinancialAccountType

  association [0..1] to ZSTRFI11_VH_MATCH      as _PayeeMatchStatus     on  $projection.PayeeMatchStatus = _PayeeMatchStatus.value_low
  association [0..1] to ZSTRFI11_VH_API        as _APITransStatus       on  $projection.APITransStatus = _APITransStatus.value_low

{
      @EndUserText.label: '실행일'
  key PaymentProposalPayment.laufd                 as PaymentRunDate,
      @EndUserText.label: '매개변수ID'
  key PaymentProposalPayment.laufi                 as PaymentRunID,
      @EndUserText.label: '자동지급제안'
  key PaymentProposalPayment.xvorl                 as PaymentRunIsProposal,
      @EndUserText.label: '지급회사코드'
  key PaymentProposalPayment.zbukr                 as PayingCompanyCode,
      @EndUserText.label: '공급업체코드'
  key PaymentProposalPayment.lifnr                 as Supplier,
      @EndUserText.label: '고객'
  key PaymentProposalPayment.kunnr                 as Customer,
      @EndUserText.label: '지급수령인'
  key PaymentProposalPayment.empfg                 as PaymentRecipient,
      @EndUserText.label: '지급전표번호'
  key PaymentProposalPayment.vblnr                 as PaymentDocument,
      @EndUserText.label: '계정유형'
      PaymentProposalPayment.koart                 as FinancialAccountType,
      @EndUserText.label: '센더회사코드'
      PaymentProposalPayment.absbu                 as SendingCompanyCode,
      @EndUserText.label: '만기일'
      PaymentProposalPayment.ausfd                 as PaymentDueDate,
      @EndUserText.label: '국가/지역키'
      PaymentProposalPayment.land1                 as CompanyCodeCountry,
      @EndUserText.label: '지급방법'
      PaymentProposalPayment.rzawe                 as PaymentMethod,

      @EndUserText.label: '회계연도'
      PaymentProposalPayment.gjahr                 as FiscalYear,

      @EndUserText.label: '전표전기일'
      PaymentProposalPayment.zaldt                 as PostingDate,
      @EndUserText.label: '기준일'
      PaymentProposalPayment.valut                 as ValueDate,

      @EndUserText.label: '거래은행번호'
      PaymentProposalPayment.ubnky                 as Bank,
      @EndUserText.label: '은행국가/지역'
      PaymentProposalPayment.ubnks                 as BankCountry,
      @EndUserText.label: '도로주소'
      PaymentProposalPayment.stras                 as StreetAddressName,
      @EndUserText.label: '이름'
      PaymentProposalPayment.name1                 as OrganizationBPName1,
      @EndUserText.label: '이름2'
      PaymentProposalPayment.name2                 as OrganizationBPName2,
      @EndUserText.label: '주거래은행키'
      PaymentProposalPayment.ubnkl                 as BankInternalID,
      @EndUserText.label: '자사계정번호'
      PaymentProposalPayment.ubknt                 as BankAccount,
      @EndUserText.label: '은행계좌번호'
      PaymentProposalPayment.ubknt_long            as BankAccountLongID,
      @EndUserText.label: '주거래은행'
      PaymentProposalPayment.hbkid                 as HouseBank,
      @EndUserText.label: '계좌ID'
      PaymentProposalPayment.hktid                 as HouseBankAccount,

      @EndUserText.label: '공급업체이름'
      PaymentProposalPayment.znme1                 as PayeeName,
      @EndUserText.label: '수취인명'
      PaymentProposalPayment.znme2                 as PayeeAdditionalName,
      @EndUserText.label: '수취인국가/지역'
      PaymentProposalPayment.zbnks                 as PayeeBankCountry,

      @EndUserText.label: '수취인은행번호'
      PaymentProposalPayment.zbnkl                 as PayeeBank,
      @EndUserText.label: '수취인은행키'
      PaymentProposalPayment.zbnky                 as PayeeBankKey,
      @EndUserText.label: '수취인계정번호'
      PaymentProposalPayment.zbnkn                 as PayeeBankAccount,
      @EndUserText.label: '수취인은행계좌번호'
      PaymentProposalPayment.zbnkn_long            as PayeeBankAccountLongID,
      @EndUserText.label: '수취인계정보유자'
      PaymentProposalPayment.koinh                 as PayeeBankAccountHolderName,

      @EndUserText.label: '지급액(기능통화)'
      @Semantics.amount.currencyCode: 'PaymentCurrency'
      PaymentProposalPayment.rbetr                 as PaymentAmountInFunctionalCrcy,

      PaymentProposalPayment.waers                 as PaymentCurrency,


      @EndUserText.label: '예금주일치'
      PaymentProposalPayment.accnt_match           as PayeeMatch,

      @EndUserText.label: '예금주일치상태'
      PaymentProposalPayment.accnt_m_status        as PayeeMatchStatus,

      case
      when PaymentProposalPayment.accnt_m_status = 'S' then 3
      else 1
      end                                          as PayeeMatchCriticality,


      @EndUserText.label: 'API전송'
      PaymentProposalPayment.api_trans             as APITrans,

      @EndUserText.label: 'API전송상태'
      PaymentProposalPayment.api_trans_status      as APITransStatus,

      case
      when PaymentProposalPayment.api_trans_status = 'S' then 3
      else 1
      end                                          as APITransStatusCriticality,


      @EndUserText.label: '잔액조회결과'
      PaymentProposalPayment.check_balance         as CheckBalance,

      @EndUserText.label: '처리결과'
      PaymentProposalPayment.process_result        as ProcessResult,

      @EndUserText.label: 'ISSUENO'
      PaymentProposalPayment.issue_no              as ISSUENO,

      @EndUserText.label: '역분개전표'
      Journal.ReverseDocument                      as ReverseDocument,

      case
      when Journal.ReverseDocument = '' then 0
      else 1
      end                                          as ReverseDocumentStatus,

      @Semantics.user.createdBy: true
      PaymentProposalPayment.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      PaymentProposalPayment.created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      PaymentProposalPayment.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      PaymentProposalPayment.local_last_changed_at as LocalLastChangedAt,
      @Semantics.user.lastChangedBy: true
      PaymentProposalPayment.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      PaymentProposalPayment.last_changed_at       as LastChangedAt,

      _PaymentProposalItem,

      _CompanyCode,
      _Supplier,
      _Customer,
      _PaymentCurrency,
      _PaymentMethod,
      _SendingCompanyCode,
      _BankCountry,
      _Bank,
      _HouseBank,
      _PayeeBank,
      _PayeeBankCountry,
      _FinancialAccountType,

      _PayeeMatchStatus,
      _APITransStatus

}
