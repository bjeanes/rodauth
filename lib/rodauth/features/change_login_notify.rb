# frozen-string-literal: true

module Rodauth
  Feature.define(:change_login_notify, :ChangeLoginNotify) do
    depends :change_login, :email_base

    translatable_method :login_changed_email_subject, 'Login Changed'
    translatable_method :login_change_requested_email_subject, 'Login Change Requested'

    auth_value_methods(
      :login_changed_email_body
    )
    auth_methods(
      :create_login_changed_email,
      :send_login_changed_email
    )

    private

    def send_login_changed_email
      send_email(create_login_changed_email)
    end

    def create_login_changed_email
      create_email_to(@login_changed_from, login_changed_email_subject, login_changed_email_body)
    end

    def login_changed_email_body
      render('login-changed-email')
    end

    def before_change_login
      super
      @login_changed_from = account_ds.get(login_column)
    end

    def after_change_login
      super
      send_login_changed_email
    end
  end
end

