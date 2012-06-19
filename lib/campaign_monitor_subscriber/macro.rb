module CampaignMonitorSubscriber
  module Macro
    def subscribe_me_using(email_field, options = {})
      extend CampaignMonitorSubscriber::BasicConfiguration
      # Don't active CMS hooks if there is no configuration for the
      # current environment.
      return if raw_cms_config.nil?

      # Now that we know CMS subscription is relevant we
      # include the required libraries and bootstrap the hooks
      require 'createsend'
      require 'campaign_monitor_subscriber/configuration'
      require 'campaign_monitor_subscriber/instance_methods'
      require 'campaign_monitor_subscriber/subscription_hooks'

      # Load configuration from the yaml file and this macro's options
      extend CampaignMonitorSubscriber::Configuration
      load_cms_configuration(email_field, options)

      # Include CMS config accessors to this model
      include CampaignMonitorSubscriber::InstanceMethods
      # Include CMS subscription hooks in this model
      include CampaignMonitorSubscriber::SubscriptionHooks
    end
  end
end
