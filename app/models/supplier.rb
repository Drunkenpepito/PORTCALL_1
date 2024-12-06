class Supplier < ApplicationRecord
  before_validation :set_cw
  has_many :contracts
  has_rich_text :description

  # validation
  # validates :description, presence: true, length: { maximum: 500 }
  # validates :contact, presence: true
  validates :cw, inclusion: { in: [true, false] }

  def self.get_and_update_suppliers_list
    page_nb = 1
    loop do
      response = ShorepApi.new.get_suppliers(page_nb)
      break if page_nb != 1 && page_nb > response['meta']['total_pages']
      response['suppliers'].each do |supplier|
        update_or_create_external_supplier(supplier)
      end
      page_nb += 1
    end
  end

  private

  def self.update_or_create_external_supplier(supplier_hash)
    supplier = Supplier.find_by(external_id: supplier_hash['id'])
    if supplier
      supplier.update!(
        description: supplier_hash['description'].empty? ? 'No description' : supplier_hash['description'],
        name: supplier_hash['name'],
        contact: supplier_hash['contact'],
        cw: supplier_hash['cw'] == true,
        external_id: supplier_hash['id']) if supplier.updated_at.to_time < supplier_hash['updated_at'].to_time # MAJ if Portcal is older
      else
        Supplier.create!(description: supplier_hash['description'].empty? ? 'No description' : supplier_hash['description'],
        name: supplier_hash['name'],
        contact: supplier_hash['contact'],
        cw: supplier_hash['cw'] == true,
        external_id: supplier_hash['id'],
        updated_at: supplier_hash['updated_at'])
        # Rails.logger.info("Supplier #{supplier.name} created")
    end
  end

  private

  def set_cw
    self.cw = false if cw.nil?
  end
end
