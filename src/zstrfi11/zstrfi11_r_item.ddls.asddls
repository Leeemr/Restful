@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 지급 이제 요청 - 아이템 BO'
define view entity ZSTRFI11_R_ITEM
  as select from zstrfi11_aitem as PaymentProposalItem

  association        to parent ZSTRFI11_R_HEADER  as _PaymentProposalPayment  on  $projection.PaymentRunID         = _PaymentProposalPayment.PaymentRunID
                                                                              and $projection.PaymentRunDate       = _PaymentProposalPayment.PaymentRunDate
                                                                              and $projection.PaymentDocument      = _PaymentProposalPayment.PaymentDocument
                                                                              and $projection.PaymentRunIsProposal = _PaymentProposalPayment.PaymentRunIsProposal
                                                                              and $projection.PayingCompanyCode    = _PaymentProposalPayment.PayingCompanyCode
                                                                              and $projection.Supplier             = _PaymentProposalPayment.Supplier
                                                                              and $projection.Customer             = _PaymentProposalPayment.Customer
                                                                              and $projection.PaymentRecipient     = _PaymentProposalPayment.PaymentRecipient

  association [0..1] to I_Supplier                as _Supplier                on  $projection.Supplier = _Supplier.Supplier
  association [0..1] to I_Customer                as _Customer                on  $projection.Customer = _Customer.Customer

  association [0..1] to I_CompanyCode             as _CompanyCode             on  $projection.PayingCompanyCode = _CompanyCode.CompanyCode

  association [0..1] to I_Currency                as _PaymentCurrency         on  $projection.PaymentCurrency = _PaymentCurrency.Currency

  association [0..1] to I_OperationalAcctgDocItem as _OperationalAcctgDocItem on  $projection.CompanyCode            = _OperationalAcctgDocItem.CompanyCode
                                                                              and $projection.FiscalYear             = _OperationalAcctgDocItem.FiscalYear
                                                                              and $projection.AccountingDocument     = _OperationalAcctgDocItem.AccountingDocument
                                                                              and $projection.AccountingDocumentItem = _OperationalAcctgDocItem.AccountingDocumentItem

  association [0..1] to I_AccountingDocumentType  as _AccountingDocumentType  on  $projection.AccountingDocumentType = _AccountingDocumentType.AccountingDocumentType

  association [0..1] to I_DebitCreditCode         as _DebitCreditCode         on  $projection.DebitCreditCode = _DebitCreditCode.DebitCreditCode
  association [0..1] to I_Housebank               as _HouseBank               on  $projection.PayingCompanyCode = _HouseBank.CompanyCode
                                                                              and $projection.HouseBank         = _HouseBank.HouseBank

  association [0..1] to I_GLAccountInCompanyCode  as _GLAccountInCompanyCode  on  $projection.PayingCompanyCode = _GLAccountInCompanyCode.CompanyCode
                                                                              and $projection.GLAccount         = _GLAccountInCompanyCode.GLAccount

{

          @EndUserText.label: '실행일'
  key     laufd                 as PaymentRunDate,
          @EndUserText.label: '매개변수ID'
  key     laufi                 as PaymentRunID,
          @EndUserText.label: '자동지급이제안됨'
  key     xvorl                 as PaymentRunIsProposal,
          @EndUserText.label: '지급회사코드'
  key     zbukr                 as PayingCompanyCode,
          @EndUserText.label: '공급업체'
  key     lifnr                 as Supplier,
          @EndUserText.label: '고객'
  key     kunnr                 as Customer,
          @EndUserText.label: '지급수령인'
  key     empfg                 as PaymentRecipient,
          @EndUserText.label: '지급전표번호'
  key     vblnr                 as PaymentDocument,
          @EndUserText.label: '회사코드'
  key     bukrs                 as CompanyCode,
          @EndUserText.label: '분개'
  key     belnr                 as AccountingDocument,
          @EndUserText.label: '회계연도'
  key     gjahr                 as FiscalYear,
          @EndUserText.label: '전기뷰항목'
  key     buzei                 as AccountingDocumentItem,
          @EndUserText.label: '분개유형'
          blart                 as AccountingDocumentType,
          @EndUserText.label: '전기일'
          bldat                 as DocumentDate,
          @EndUserText.label: '계산대상기준일'
          zfbdt                 as DueCalculationBaseDate,
          @EndUserText.label: '지급방법'
          zlsch                 as PaymentMethod,
          @EndUserText.label: '전기일'
          budat                 as PostingDate,
          @EndUserText.label: '항목텍스트'
          sgtxt                 as DocumentItemText,
          @EndUserText.label: 'G/L계정'
          hkont                 as GLAccount,
          @EndUserText.label: '세금코드'
          mwskz                 as TaxCode,

          @Semantics.amount.currencyCode: 'PaymentCurrency'
          //          @Aggregation.default: #SUM
          @EndUserText.label: '금액'
          case
            when shkzg = 'H' then cast(-wrbtr as abap.curr( 23, 2 ))
            else cast(wrbtr as abap.curr( 23, 2 ))
          end                   as AmountInTransactionCurrency,

          @EndUserText.label: '자동지급통화'
          waers                 as PaymentCurrency,
          @EndUserText.label: '차변/대변코드'
          shkzg                 as DebitCreditCode,
          @EndUserText.label: '사업장'
          bupla                 as BusinessPlace,
          @EndUserText.label: '주거래은행'
          hbkid                 as HouseBank,
          @EndUserText.label: '운영G/L계정'
          saknr                 as BankReconciliationAccount,
          @EndUserText.label: '지급방법'
          zwels                 as ConsideredPaymentMethods,

          @Semantics.user.createdBy: true
          created_by            as CreatedBy,
          @Semantics.systemDateTime.createdAt: true
          created_at            as CreatedAt,
          @Semantics.user.localInstanceLastChangedBy: true
          local_last_changed_by as LocalLastChangedBy,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          local_last_changed_at as LocalLastChangedAt,
          @Semantics.user.lastChangedBy: true
          last_changed_by       as LastChangedBy,
          @Semantics.systemDateTime.lastChangedAt: true
          last_changed_at       as LastChangedAt,

          _PaymentProposalPayment,
          _Supplier,
          _Customer,
          _CompanyCode,
          _PaymentCurrency,
          _OperationalAcctgDocItem,
          _AccountingDocumentType,
          _DebitCreditCode,
          _HouseBank,
          _GLAccountInCompanyCode

}
