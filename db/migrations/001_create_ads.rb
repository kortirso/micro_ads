# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:ads) do
      primary_key :id
      String :title, unique: false, null: false
      Text :description, unique: false, null: false
      String :city, unique: false, null: false
      Float :lat, unique: false, null: true
      Float :lon, unique: false, null: true
      Integer :user_id, unique: false, null: false
      DateTime :created_at
      DateTime :updated_at
      index [:user_id]
    end
  end

  down do
    drop_table(:ads, cascade: true)
  end
end
