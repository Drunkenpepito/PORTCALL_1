class Supplier < ApplicationRecord

  before_validation :set_cw
  # has_many :contracts
  has_rich_text :description

  # validation
  # validates :description, presence: true, length: { maximum: 500 }
  # validates :contact, presence: true
  validates :cw, inclusion: { in: [true, false] }

  # ALLOW attributes to be searched WITH RANSACK
  def self.ransackable_attributes(auth_object = nil)
    ["contact", "name"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["contact", "name"]
  end

  def self.dl_and_update_suppliers_list
    all_suppliers = Supplier.all
    page_nb = 1
    loop do
      response = ShorepApi.new.get_suppliers(page_nb) # get the suppliers list from API SHOREP with page NB
      break if page_nb != 1 && page_nb > response['meta']['total_pages']
      response['suppliers'].each do |supplier|
        update_or_create_external_supplier(all_suppliers,supplier)
      end
      page_nb += 1
    end
  end

  private

  def self.update_or_create_external_supplier(all_suppliers,supplier_hash)
    supplier = all_suppliers.find{|s|s.external_id== supplier_hash['id'].to_i}
    if supplier
      Rails.logger.info("Supplier #{supplier.name} already exists")
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

  def set_cw
    self.cw = false if cw.nil?
  end
end
