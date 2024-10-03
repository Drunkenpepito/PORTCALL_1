class InvoiceMailer < ApplicationMailer
  def db_backup
    @greeting = "Hi"
    attachments['db_invoices.csv'] = File.read('app/assets/db_invoices.csv')

    mail(
      to:"pierre.furic@ge.com; pfuric@hotmail.com",
      cc:"operations@shorerep.com",
      from:"shorerep21@gmail.com",
      subject: "DB back up "
    )
  end
end
