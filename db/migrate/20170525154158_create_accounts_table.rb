Sequel.migration do
  up do
    create_table?(:accounts) do
      primary_key :id
      String :uid, null: false, unique: true
      String :queue_name, null: false, unique: true
      DateTime :created_at, null: false
      DateTime :updated_at
      DateTime :last_login
    end
  end

  down do
    drop_table(:accounts)
  end
end
