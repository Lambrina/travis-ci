class Build
  module Notifications
    def send_email_notifications?
      emails_enabled? && email_recipients.present?
    end

    def email_recipients
      @email_recipients ||= notifications[:email] || notifications[:recipients] || default_email_recipients # TODO deprecate recipients
    end

    [:webhook, :campfire].each do |notification|
      define_method "send_#{notification}_notifications?" do
        !!notifications[notification]
      end
    end

    def webhooks
      Array(notifications[:webhooks]).map { |webhook| webhook.split(' ') }.flatten.map(&:strip).reject(&:blank?)
    end

    protected

      def emails_enabled?
        if notifications.blank?
          true
        elsif emails_disabled?
          false
        else
          true
        end
      end

      def emails_disabled?
        notifications[:email] == false || notifications[:disabled] || notifications[:disable] # TODO deprecate disabled and disable
      end

      def default_email_recipients
        recipients = [commit.committer_email, commit.author_email, repository.owner_email]
        recipients.select(&:present?).join(',').split(',').map(&:strip).uniq.join(',')
      end

      def notifications
        config.fetch(:notifications, {})
      end
  end
end
