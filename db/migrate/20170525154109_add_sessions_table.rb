Sequel.migration do
  change do
    create_table :sessions do
      primary_key :id
      String :session_id, null: false, unique: true, index: true
      String :data, text: true, null: false
      DateTime :updated_at, null: true, index: true
    end
  end
end
