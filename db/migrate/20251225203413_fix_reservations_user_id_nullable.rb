class FixReservationsUserIdNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :reservations, :user_id, true
    change_column_default :reservations, :user_id, nil
  end
end
