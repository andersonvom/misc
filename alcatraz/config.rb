#!/usr/bin/ruby

require 'mail'

RECIPIENT = "username@example.com"
FROM = "company@example.com" # if using gmail, this only matters if you have a custom domain
SUBJECT = "New Tickets Available"

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'gmail.com',
            :user_name            => 'username',
            :password             => 'password',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

Mail.defaults do
  delivery_method :smtp, options
end

