class AddCompanyReferenceToQuotes < ActiveRecord::Migration[7.0]
  def change
    # This will add the `company_id` foreign key to the quotes table
    add_reference :quotes, :company, null: false, foreign_key: true
  end
end
