module PurchaseOrdersHelper
  def build_xls_template(rows=nil)
    p = Axlsx::Package.new
    wb = p.workbook
    unless rows
      rows = ['First', 'Second', 'Third']
    end

    wb.add_worksheet(name: 'My Form') do |sheet|
      sheet.add_row rows
    end

    p.serialize(file = prepare_file('my_template').path)
    file
  end

  def prepare_file(file_name)
    temp_file = Tempfile.new([file_name, '.xlsx'], encoding: 'ascii-8bit')
    temp_file
  end
end
