class AddEmailToReservations < ActiveRecord::Migration[8.1]
  def change
    add_column :reservations, :email, :string
  end
end
