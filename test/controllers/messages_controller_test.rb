require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest

  def sign_in(uid)
    OmniAuth.config.mock_auth[:developer] = OmniAuth::AuthHash.new({
      :uid => uid
    })
    post '/auth/developer/callback',headers: { "Accept" => "application/json" }
  end

  test 'can read messages' do
    account = create_account('default_test_user')
    generate_queue_messages(account.queue, 10)
    sign_in("default_test_user")
    get '/messages', params: { }, headers: { "Accept" => "application/json" }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 10, json["totalMessages"]
    assert_equal 10, json["totalReturned"]
    assert_equal 10, json["messages"].length
  end

  test 'cannot read others messages' do
    create_account('default_test_user')
    account2 = create_account('default_test_user2', 'test_queue2', false)
    generate_queue_messages(account2.queue, 10)
    sign_in("default_test_user")
    get '/messages', params: { }, headers: { "Accept" => "application/json" }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 0, json["totalMessages"]
    assert_equal 0, json["totalReturned"]
    assert_equal 0, json["messages"].length
  end

  test 'can mark message read ' do
    account = create_account('default_test_user')
    generate_queue_messages(account.queue, 10)
    sign_in("default_test_user")
    m = account.queue.first
    assert_equal "queued", m[:status]
    post "/messages/#{m[:id]}/read", headers: { "Accept" => "application/json" }
    assert :success
    m = account.queue.first(id: m[:id])
    assert_equal "read", m[:status]
  end

  test 'can bulk mark messages read ' do
    account = create_account('default_test_user')
    generate_queue_messages(account.queue, 10)
    account.queue.all.each do |message|
      assert_equal "queued", message[:status]
    end

    ids = account.queue.all.pluck(:id)
    sign_in("default_test_user")
    post "/messages/read" ,{:ids =>ids}, headers: {"CONTENT_TYPE" => 'application/json'}
    assert :success
    account.queue.all.each do |message|
      assert_equal "read", message[:status]
    end
  end


  test 'read messages are not returned in results' do
    account = create_account('default_test_user')
    generate_queue_messages(account.queue, 10)
    messages = account.queue.limit(5)
    messages.each do |message|
      account.queue.where(id: message[:id]).update(status: "read")
    end
    sign_in("default_test_user")
    get '/messages', params: { }, headers: { "Accept" => "application/json" }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 5, json["totalMessages"]
    assert_equal 5, json["totalReturned"]
    assert_equal 5, json["messages"].length
  end

  test 'can limit messages ' do
      account = create_account('default_test_user')
      generate_queue_messages(account.queue, 10)

      sign_in("default_test_user")
      get '/messages', params: {limit: 5 }, headers: { "Accept" => "application/json" }
      assert_response :success

      json = JSON.parse(response.body)
      assert_equal 10, json["totalMessages"]
      assert_equal 5, json["totalReturned"]
      assert_equal 5, json["messages"].length
  end

  test 'must be authenticated' do
    get '/messages'
    assert_redirected_to 'http://www.example.com/auth/developer'
  end
end
