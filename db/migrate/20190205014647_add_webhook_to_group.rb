class AddWebhookToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :webhook, :string
  end
end
