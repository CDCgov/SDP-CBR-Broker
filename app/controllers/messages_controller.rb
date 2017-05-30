class MessagesController < ApplicationController
  before_action :authenticate_user!
  def index
    limit = params[:limit]
    messages = current_user.queue.where { status !~ 'read' }
    @count = messages.count
    messages.update_sql(attempts: Sequel.expr(1) + :attempts)
    @messages = limit && limit.to_i > 0 ? messages.limit(limit).all : messages.all
  end

  def show
    message = current_user.queue.first(id: params[:id])
    render status: 404, plain: 'no' unless message
  end

  def mark_message_read
    message = current_user.queue.first(id: params[:id])
    render status: 404, plain: 'no' unless message
    set_message_read(message, current_user.queue)
    render status: 204, plain: 'marked as read '
  end

  def bulk_mark_messages_read
    current_user.queue.where(id: params[:ids]).each do |message|
      set_message_read(message, current_user.queue)
    end
    render status: 204, plain: ""
  end

  private

  def set_message_read(message, queue)
    queue.where(id: message[:id]).update(status: 'read',
                                         payload: '',
                                         cbr_delivered_time: Time.now)
  end
end
