class AddCompanyReferenceToUsers < ActiveRecord::Migration[7.0]
  def change
    # This will add the `company_id` foreign key to the users table
    add_reference :users, :company, null: false, foreign_key: true
  end
end
