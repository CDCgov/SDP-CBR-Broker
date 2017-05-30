Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      column :uid, "text", :null=>false
      column :queue_name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone"
      column :last_login, "timestamp without time zone"
      
      index [:queue_name], :name=>:accounts_queue_name_key, :unique=>true
      index [:uid], :name=>:accounts_uid_key, :unique=>true
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:sessions) do
      primary_key :id
      column :session_id, "text", :null=>false
      column :data, "text", :null=>false
      column :updated_at, "timestamp without time zone"
      
      index [:session_id]
      index [:session_id], :name=>:sessions_session_id_key, :unique=>true
      index [:updated_at]
    end
    
    create_table(:test_queue) do
      primary_key :id
      column :cbr_id, "text", :null=>false
      column :source, "text", :null=>false
      column :source_id, "text", :null=>false
      column :source_attributes, "text"
      column :batch, "boolean", :default=>false
      column :batch_id, "text"
      column :batch_index, "text"
      column :payload, "text", :null=>false
      column :cbr_recevied_time, "text", :null=>false
      column :cbr_delivered_time, "text"
      column :sender, "text"
      column :recipient, "text"
      column :errorCode, "text"
      column :errorMessage, "text"
      column :attempts, "integer", :default=>0
      column :status, "text", :default=>"queued", :null=>false
      column :created_at, "text"
      column :updated_at, "text"
    end
  end
end
              Sequel.migration do
                change do
                  self << "SET search_path TO \"$user\", public"
                  self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170525154109_add_sessions_table.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20170525154158_create_accounts_table.rb')"
                end
              end
