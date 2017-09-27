class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def x509_user_public_key
    pk = request.env['puma.peercert'].to_pem
    pk.gsub(/-----.{3,5} CERTIFICATE-----|\n/, '')
  end

  def x509_user_subject(target)
    # you can get O, OU, or CN from this
    target = target.upcase
    subject_array = request.env['puma.peercert'].subject.to_a.flatten
    target_index = subject_array.index(target)
    subject_array[target_index + 1] if target_index
  end

  def current_user
    @current_user ||= Account.first(uid: x509_user_subject('cn'))
  rescue StandardError
    nil
  end

  def authenticate_user!
    unless current_user
      render file: "#{Rails.root}/public/403.html", status: :forbidden
    end
  end
end
