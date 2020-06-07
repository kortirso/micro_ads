# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:ads) do
      primary_key :id, type: :Bignum

      String :title, unique: false, null: false, fixed: true
      String :city, unique: false, null: false, fixed: true
      Text :description, unique: false, null: false

      Float :lat, unique: false, null: true
      Float :lon, unique: false, null: true

      Integer :user_id, unique: false, null: false

      column :created_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')
      column :updated_at, 'timestamp(6) without time zone', null: false, default: Sequel.lit('now()')

      index [:user_id]
    end
  end

  down do
    drop_table(:ads, cascade: true)
  end
end
