# frozen_string_literal: true

Sequel.migration do
  up do
    add_column :ads, :correlation_id, String
  end

  down do
    drop_column :ads, :correlation_id
  end
end
