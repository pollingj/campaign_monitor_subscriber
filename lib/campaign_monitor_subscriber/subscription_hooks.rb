# This module defines the CMS subscription callbacks.
# The callbacks are included in a model that calls #subscribe_me_using.
module CampaignMonitorSubscriber
  module SubscriptionHooks

    extend ActiveSupport::Concern

    included do
      require 'logger'
      @@log = Logger.new('log/cm_subscriber.log')

      after_create do |record|
        @@log.debug "\n* Adding '#{record.cms_email}' to CM"

        begin
          CreateSend::Subscriber.add(
            cms_config.list_id,
            record.cms_email,
            record.cms_name,
            record.cms_custom_fields,
            true
          )
        rescue CreateSend::CreateSendError => err
          @@log.info err.message
        end
      end


      after_destroy do |record|
        @@log.debug "\n* Removing '#{record.cms_email}' from CM"

        begin
          s = CreateSend::Subscriber.new(
            cms_config.list_id,
            record.cms_email
          )
          s.unsubscribe
        rescue CreateSend::CreateSendError => err
          @@log.info err.message
        end
      end

      after_save do |record|
        @@log.debug "\n* Updating '#{record.cms_email}' from CM"
        
        begin
          s = CreateSend::Subscriber.new(cms_config.list.id, record.cms_email)
          s.update(record.cms_email, record.cms_name, record.cms_custom_fields, false)
        rescue CreateSend::CreateSendError => err
          @@log.info err.message
        end
      end
    end
  end
end
