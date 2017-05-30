require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test 'account creates queue if not available' do
    delete_account('qt')
    assert !Account.db.table_exists?(:qt_queue), 'table should not exist'
    acc = create_account('qt', false)
    acc.queue
    assert Account.db.table_exists?(:qt_queue), 'table should  exist'
    acc.delete(true)
  end

  test 'can destroy account and leave queue' do
    acc = create_account('qt', true)
    acc.queue
    assert Account.db.table_exists?(:qt_queue), 'table should  exist'
    acc.delete
    assert Account.db.table_exists?(:qt_queue), 'table should  exist'
  end

  test 'can destroy account and queue' do
    acc = create_account('qt', true)
    acc.queue
    assert Account.db.table_exists?(:qt_queue), 'table should  exist'
    acc.delete(true)
    assert !Account.db.table_exists?(:qt_queue), 'table should not exist'
  end
end
