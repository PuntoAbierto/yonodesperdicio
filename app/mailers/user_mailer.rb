class UserMailer < ActionMailer::Base
  default from: Rails.application.secrets.emails["default_from"]

  def confirmation_reminder(resource)
    @resource = resource
    mail(
      to: @resource.email,
      subject: "[Yonodesperdicio.org] Falta que confirmes tu cuenta"
    )
  end

end
