#!/usr/bin/env ruby 

require 'rubygems'
# This uses two gems: garb and ruby-growl
# to install, type '# sudo gem install vigetlabs-garb ruby-growl'
# See http://www.viget.com/extend/introducing-garb-access-the-google-analytics-data-export-api-with-ruby
require 'garb'
require 'ruby-growl'

google_username = ENV['GOOGLE_USERNAME']
google_password = ENV['GOOGLE_PASSWORD']
growl = true

# TODO configure metrics to grab
# TODO configure dimensions
# TODO configure where to growl

Garb::Session.login(google_username,google_password)
p = Garb::Profile.all
p.each do |profile|
  report = Garb::Report.new(profile, :start_date => Time.now)
  report.metrics :pageviews, :visitors
  report.dimensions :date
  report.results.each do |day|
    # only creates a message if there are pageviews
    message = "#{day.pageviews} pageviews, #{day.visitors} visitors" if day.pageviews.to_i > 0
    if growl && !message.blank?
      g = Growl.new "localhost", "ruby-growl", ["ruby-growl Notification"] #, ["ruby-growl Notification"]
      g.notify "ruby-growl Notification", message, "#{profile.title}"
    else
      puts "#{day.pageviews} from #{day.visitors} visitors on #{profile.title}" if day.pageviews.to_i > 0
    end
  end
end