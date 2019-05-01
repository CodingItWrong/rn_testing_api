class MakeApplicationIdNullableOnTokens < ActiveRecord::Migration[5.2]
  def up
    change_column :oauth_access_tokens, :application_id, :bigint, null: true
  end

  def down
    change_column :oauth_access_tokens, :application_id, :bigint, null: false
  end
end
