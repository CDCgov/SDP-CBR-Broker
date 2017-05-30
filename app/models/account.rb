class Account < Sequel::Model
  plugin :whitelist_security
  plugin :validation_helpers
  set_allowed_columns :uid, :queue_name, :created_at, :updated_at
  def validate
    super
    validates_presence [:uid, :queue_name]
  end

  def queue
    ensure_queue
    Account.db[queue_name.to_sym]
  end

  def delete(drop_queue = false)
    Account.db.drop_table?(queue_name) if drop_queue
    super()
  end

  private

  def ensure_queue
    Account.db.create_table?(queue_name) do
      primary_key :id
      String :cbr_id, null: false
      String :source, null: false
      String :source_id, null: false
      String :source_attributes
      boolean :batch, default: false
      String :batch_id, null: true
      String :batch_index
      String :payload, null: false
      String :cbr_recevied_time, null: false
      String :cbr_delivered_time, null: true
      String :sender, null: true
      String :recipient, null: true
      String :errorCode, null: true
      String :errorMessage, null: true
      Integer :attempts, default: 0
      String :status, null: false, default: 'queued'
      String :created_at, null: true
      String :updated_at, null: true
    end
  end
end
