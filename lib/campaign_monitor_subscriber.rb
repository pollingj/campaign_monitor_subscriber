require 'campaign_monitor_subscriber/basic_configuration'
require 'campaign_monitor_subscriber/macro'

ActiveRecord::Base.extend(CampaignMonitorSubscriber::Macro)
