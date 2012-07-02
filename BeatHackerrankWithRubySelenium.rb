=begin
  Title: BeatHackerrankWithRubySelenium.rb
  Author: Dave Guarino (daguar on github; daguar@gmail.com)
  Date: July 7, 2012
  Version: 0.11 (alpha)
  Description: Simple script that uses Selenium (Ruby webdriver) to beat the first HackerRank challenge
  Notes: You need to add your login and password below before running. Make sure you've got Firefox, and you've gem-installed selenium-webdriver, then just run it with "ruby BeatHackerrankWithRubySelenium.rb'!
  Caveat: This was really a toy exercise to learn Selenium, so it's ugly as hell and won't compete with other approaches. But I had a ton of fun!
  License: Beer-Ware
  ----------------------------------------------------------------------------
  "THE BEER-WARE LICENSE" (Revision 42):
  Dave Guarino <daguar@gmail.com> wrote this file. As long as you retain this 
  notice you can do whatever you want with this stuff. If we meet some day, and 
  you think this stuff is worth it, you can buy me a beer in return.
  ----------------------------------------------------------------------------
=end

require 'rubygems'
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.get "http://www.hackerrank.com"

wait = Selenium::WebDriver::Wait.new(:timeout => 10, :interval => 2)

# The config variables
login = "your username here"
password = "your password here"

# Start with 7, since it is the first integer not divisible by (but greater than) 6
startnumber = 7
# Go until stated max; this has been increased once already, so say change again
max = 2560

# Log in
element = driver.find_element :id => "prompt-input"
element.send_keys "login #{login}", :return
sleep 0.5
element = driver.find_element :id => "session-password"
element.send_keys password, :return
sleep 1

# Start beating it!
while startnumber < max do
  if startnumber % 6 == 0
    startnumber = startnumber + 1
  end
  sleep 1
  puts "Starting Number: #{startnumber}"
  element = driver.find_element :id => "prompt-input"
  element.send_keys "challenge #{startnumber}", :return
  sleep 1
  element = driver.find_element :id => "game-input"
  step = startnumber % 6
  element.send_keys step.to_s, :return
  sleep 1
  elements = driver.find_elements(:xpath, '//*[@id="game-output"]')
  remaining = /Remaining candies: '(.+)'/.match(elements[0].text)[1]
  puts remaining
  while driver.find_elements(:xpath, '//*[@id="game-output"]')[0].class != NilClass do
    puts "class of the element #{driver.find_elements(:xpath, '//*[@id="game-output"]')[0].class}"
    element = driver.find_element(:xpath, '//*[@id="game-output"]').text.to_s.gsub(/\n/, " ");
    puts "element: #{element}"
    /.*Remaining candies: '(\d+)'.*/ =~ element
    puts "captures #{$~.captures}"
    remaining = $~.captures[-1].to_i
    puts "#{remaining} remaining"
    step = remaining % 6
    puts "step #{step}"
    element = driver.find_element :id => "game-input"
    element.send_keys step.to_s, :return
    sleep 1.2
  end
  startnumber = startnumber + 1
end

# Give 'er a rest
sleep 10

driver.quit
