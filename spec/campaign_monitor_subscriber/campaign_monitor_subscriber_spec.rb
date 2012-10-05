require 'spec_helper'

describe 'Subscription hook' do
  context "when the current environment has no configuration specified" do
    before(:each) do
      Rails.stub(:env).and_return('test')
      Monkey.subscribe_me_using :email
    end

    it "doesn't activate CMS subscription hooks" do
      Monkey.should_not_receive(:load_cms_configuration)
      Monkey.new
    end
  end

  context "when no :name is specified in #subscribe_me_using" do
    before(:each) do
      Monkey.subscribe_me_using :email
    end

    it "makes the correct call to the CreateSend::Subscriber.add method" do
      CreateSend::Subscriber.should_receive(:add).with('generic_list_id',
                                                       'monkey@gmail.com',
                                                       'monkey@gmail.com',
                                                       [{}],
                                                       true)
      Monkey.new.after_create
    end
  end

  context "when no list is specified in #subscribe_me_using" do
    before(:each) do
      Monkey.subscribe_me_using :email, :name => :full_name, :status => :user_status
    end

    it "makes the correct call to the CreateSend::Subscriber.add method" do
      CreateSend::Subscriber.should_receive(:add).with('generic_list_id',
                                                       'monkey@gmail.com',
                                                       'monkey man',
                                                       [{'status' => 'new'}],
                                                       true)
      Monkey.new.after_create
    end
  end

  context "when a list is specified in #subscribe_me_using" do
    before(:each) do
      Monkey.subscribe_me_using :email, :name => :full_name, :status => :user_status, :list => :monkey
    end

    it "makes the correct call to the CreateSend::Subscriber.add method" do
      CreateSend::Subscriber.should_receive(:add).with('monkey_list_id',
                                                       'monkey@gmail.com',
                                                       'monkey man',
                                                       [{'status' => 'new'}],
                                                       true)
      Monkey.new.after_create
    end
  end
end

describe 'Unsubscription hook' do
  context "when no list is specified in #subscribe_me_using" do
    before(:each) do
      Monkey.subscribe_me_using :email, :name => :full_name, :status => :user_status
    end

    it "makes the correct call to the CreateSend::Subscriber#destroy method" do
      subscriber = double('CreateSend::Subscriber')
      CreateSend::Subscriber.should_receive(:new).with('generic_list_id', 'monkey@gmail.com').and_return(subscriber)
      subscriber.should_receive(:unsubscribe)

      Monkey.new.after_destroy
    end
  end

  context "when a list is specified in #subscribe_me_using" do
    before(:each) do
      Monkey.subscribe_me_using :email, :name => :full_name, :status => :user_status, :list => :monkey
    end

    it "makes the correct call to the CreateSend::Subscriber#destroy method" do
      subscriber = double('CreateSend::Subscriber')
      CreateSend::Subscriber.should_receive(:new).with('monkey_list_id', 'monkey@gmail.com').and_return(subscriber)
      subscriber.should_receive(:unsubscribe)

      Monkey.new.after_destroy
    end
  end
end
