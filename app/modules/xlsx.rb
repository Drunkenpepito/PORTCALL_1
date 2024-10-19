module Xlsx
  def self.po(purchase_orders)
    p = Axlsx::Package.new 
    wb = p.workbook

    style1 = wb.styles.add_style(
      border: [
        { style: :thin, color: 'CCCCCC' },
        { style: :thin, edges: [:top, :bottom] },
        { style: :thin, edges: [:left, :right] },
      ],
      alignment: { horizontal: :center },
      family: 3,
      bg_color: '09507A',
      fg_color: 'CCCCCC',
      font_name: 'calibri',
    )
    style2 = wb.styles.add_style(
      sz: 20,
      bg_color: '09507A',
      fg_color: 'CCCCCC',
      alignment: { horizontal: :center },
    )
    # image = File.expand_path('app/assets/images/logo_flat.jpeg')
    wb.add_worksheet(name: "PO") do |sheet|
      # sheet.add_row [' ', ' ', ' ', ' ', ' '] , style: style1
      # sheet.merge_cells('A1:E1')
      sheet.add_row ['PO', 'INVOICE', 'SERVICE', 'BUDGET PRICE', 'INVOICE PRICE'] , style: style2
      sheet.auto_filter = 'A1:E1'
      # sheet.add_image(image_src: image, start_at: 'A1', end_at: 'E6')
      # sheet.add_image(image_src: image, start_at: 'B2', width: 300, height: 50, noRot: true)
      purchase_orders.each do |po|
        po.invoices.each do|inv| 
          inv.orders.each { |o| sheet.add_row [po.name, inv.name, o.name, o.budget_price, o.invoice_price] , style: style1 if o.is_root? }
        end
        #   sheet.add_chart(Axlsx::Pie3DChart, :start_at => [0,5], :end_at => [10, 20], :title => "example 3: Pie Chart") do |chart|
        #     chart.add_series :data => sheet["B2:B4"], :labels => sheet["A2:A4"],  colors: ['FF0000', '00FF00', '0000FF']
        #   end
        #   
      end
    end
    return p
  end

  def self.invoice(invoice)
    p = Axlsx::Package.new 
    wb = p.workbook

    style1 = wb.styles.add_style(
      border: [
        { style: :thin, color: 'CCCCCC' },
        { style: :thin, edges: [:top, :bottom] },
        { style: :thin, edges: [:left, :right] },
      ],
      alignment: { horizontal: :center },
      family: 3,
      bg_color: '09507A',
      fg_color: 'CCCCCC',
      font_name: 'calibri',
    )
    style2 = wb.styles.add_style(
      sz: 20,
      bg_color: '09507A',
      fg_color: 'CCCCCC',
      alignment: { horizontal: :center },
    )

    wb.add_worksheet(name: "#{invoice.name}") do |sheet|
      sheet.add_row ['SERVICE', 'BUDGET PRICE', 'INVOICE PRICE', 'PARENT', 'FORMULA'] , style: style2
      sheet.auto_filter = 'A1:E1'
      invoice.orders.each { |o| sheet.add_row [o.name,o.budget_price, o.invoice_price, o.ancestry, o.formula], style: style1 }
    end
    return p
  end

end