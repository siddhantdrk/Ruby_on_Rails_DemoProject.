class CreateDomainData < ActiveRecord::Migration[5.1]
  def change
    create_table :domain_data do |t|
      t.string :user_id
      t.string :file_name
      t.string :date
      t.string :domain_rating
      t.string :domain_name

      t.timestamps
    end
  end
end
