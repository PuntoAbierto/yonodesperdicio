class ChangeUserRequiredFields < ActiveRecord::Migration
  def change
    change_column_null :ads, :woeid_code, true
    change_column_null :ads, :ip, true
  end
end
