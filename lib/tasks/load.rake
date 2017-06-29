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

namespace :load do
desc "Load a number of messages into the database"
  task :messages, [:account, :number] => :environment do |t, args|
     acc = Account.first(uid: args.account)
     generate_queue_messages(acc.queue, args.number.to_i)
  end
end
