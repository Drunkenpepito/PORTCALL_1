class AddDataToSupplier < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :description, :text
    # add_column :suppliers, :service, :string #???
    add_column :suppliers, :contact, :text
    # add_column :suppliers, :box_link, :string
    # add_column :suppliers, :category, :integer
    # add_column :suppliers, :msa, :string
    # add_column :suppliers, :ism, :string
    # add_column :suppliers, :nda, :boolean, default: false
    # add_column :suppliers, :sc, :boolean, default: false
    add_column :suppliers, :cw, :boolean, default: false #comply works
    # add_column :suppliers, :commodity, :string
    # add_column :suppliers, :region, :string
    # add_column :suppliers, :comment_onboarding, :text
  end
end
