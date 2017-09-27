ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...

  def create_account(uid, rie = false, wipe_queue = false)
    acc = Account.first(uid: uid)
    if acc && rie
      clear_queue(acc.queue) if wipe_queue
      return acc
    elsif acc
      acc.delete(true)
    end
    Account.create(uid: uid, queue_name: "#{uid}_queue",
                   created_at: Time.now,
                   updated_at: Time.now)
  end

  def drop_queue(queue_name)
    Account.db.drop_table?(queue_name)
  end

  def delete_account(uid)
    drop_queue("#{uid}_queue")
    acc = Account.first(uid: uid)
    acc.delete(true) if acc
  end

  def clear_queue(queue)
    queue.delete
  end

  def generate_queue_messages(queue, number_of_messages)
    source = 'phin'
    id = 0
    number_of_messages.times do
      id += 1
      message = { cbr_id: "#{source}_#{id}",
                  source: source,
                  source_id: "#{source}_#{id}",
                  source_attributes: generate_source_attributes,
                  batch: false,
                  batch_id: nil,
                  batch_index: 0,
                  payload: '',
                  cbr_recevied_time: Time.now,
                  cbr_delivered_time: Time.now,
                  sender: '',
                  recipient: '',
                  errorCode: '',
                  errorMessage: '',
                  attempts: 0,
                  status: 'queued',
                  created_at: Time.now,
                  updated_at: Time.now }
      queue << message
    end
  end

  def generate_source_attributes
    'RECORDID=1&MESSAGEID=&PAYLOADNAME=&LOCALFILENAME=&SERVICE=SDP-CBR&ACTION=send&ARGUMENTS=&FROMPARTYID=&MESSAGERECIPIENT=&ERRORCODE=null&ERRORMESSAGE=null&PROCESSINGSTATUS=&APPLICATIONSTATUS=&ENCRYPTION=&RECEIVEDTIME=2017-05-12 23:20:50&LASTUPDATETIME=2017-05-12 23:20:50&PROCESSID='
  end
end
