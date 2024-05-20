@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[FI] 입금 거래 내역 조회'

define root view entity ZSTRFI13_R_LIST
  as select from ZSTRFI13_I_LIST as _LIST

{
  key _LIST.TransactionKey,
  key _LIST.uuid,
      _LIST.CompanyCode,
      _LIST.SequenceNo,
      _LIST.FiscalYear,
      _LIST.AccountingDocument,
      _LIST.JournalEntryType,
      _LIST.CreditAccount,
      _LIST.CreditAccountDetail,
      _LIST.ReconciliationAccount,
      _LIST.ReconciliationDetail,
      @Consumption.valueHelpDefault.display: true
      _LIST.BankInternalID,
      _LIST.BankAccount,
      _LIST.HouseBank,
      _LIST.HouseBankAccount,
      _LIST.HouseBankName,
      _LIST.HouseBankAccountKey,
      _LIST.GLAccount,
      _LIST.TransactionDetail,
      _LIST.IncomingAmount,
      _LIST.OutgoingAmount,
      _LIST.TransactionAmount,
      _LIST.Waers,
      _LIST.TransactionGb,
      _LIST.TransactionGbName,
      _LIST.status,
      case _LIST.status
           when 'S' then 3
           when 'X' then 1
           when 'R' then 2
           when 'e' then 1
           else 2 end            as Status_icon,
      @EndUserText.label: '처리결과'
      case _LIST.status
           when 'S' then '전표생성완료'
           when 'X' then '처리제외'
           when 'R' then '전표생성준비'
           when 'E' then '에러'
           else _LIST.status end as STATUSNAME,
      case _LIST.status
      when 'S' then '전표생성완료'
      when 'X' then '처리제외'
      when 'R' then '전표생성준비'
      when 'E' then '에러'
      else _LIST.status end      as STATUSNAME2,
      _LIST.TransactionTime,
      _LIST.TransactionDate,
      _LIST.CreatedBy,
      _LIST.CreatedAt,
      _LIST.LocalLastChangedBy,
      _LIST.LocalLastChangedAt,
      _LIST.LastChangedBy,
      _LIST.LastChangedAt,

      //public associations
      _LIST._JournalEntry,
      //      _customer,
      _LIST._HouseBankAccountLinkage,
      _LIST._GlAccountTextInCompanycode

}
