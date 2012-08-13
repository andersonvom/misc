#!/usr/bin/ruby

require 'mail'

RECIPIENT = "username@example.com"
FROM = "another@example.com"
SUBJECT = "New Tickets Available"

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'gmail.com',
            :user_name            => 'USERNAME',
            :password             => 'PASSWORD',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

Mail.defaults do
  delivery_method :smtp, options
end

