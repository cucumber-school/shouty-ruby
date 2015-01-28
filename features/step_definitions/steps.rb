Before do
  @messages_shouted_by = {}
end

Given(/^the range is (\d+)$/) do |range|
  @network = Network.new(range.to_i)
end

Given(/^the following people:$/) do |table|
  table
    .transpose
    .map_column('location') { |raw_location| raw_location.to_i }
    .hashes.each do |row|
      name = row['name']
      location = row['location']
      people[name] = Person.new(@network, location)
    end
end

When(/^Sean shouts (\d+) messages containing the word "(.*?)"$/) do |num, word|
  num.to_i.times do
    sean_shout "here is a message containing the word #{word}"
  end
end

When(/^Sean shouts (\d+) over\-long messages$/) do |num|
  num.to_i.times do
    sean_shout "x" * 181
  end
end

When(/^Sean shouts an over\-long message$/) do
  sean_shout "x" * 181
end

When(/^Sean shouts a long message$/) do
  sean_shout "x" * 180
end

When(/^Sean shouts a message containing the word "(.*?)"$/) do |word|
  sean_shout "here is a message containing the word #{word}"
end

When(/^Sean shouts a message$/) do
  sean_shout "here is a message"
end

When(/^Sean shouts "(.*?)"$/) do |message|
  sean_shout message
end

When(/^Sean shouts:$/) do |message|
  sean_shout message
end

Then(/^Lucy hears Sean's message$/) do
  expect(people['Lucy'].messages_heard).to include @messages_shouted_by['Sean'].last
end

Then(/^Larry does not hear Sean's message$/) do
  expect(people['Larry'].messages_heard).to_not include @messages_shouted_by['Sean'].last
end

Then(/^nobody hears Sean's message$/) do
  people.values.each do |person|
    expect(person.messages_heard).to_not include @messages_shouted_by['Sean'].last
  end
end

Then(/^Lucy hears the following messages:$/) do |expected_messages|
  lucy = people['Lucy']
  actual_messages = lucy.messages_heard.map { |message| [ message ] }
  expected_messages.diff!(actual_messages)
end

Given(/^Sean has bought (\d+) credits$/) do |credits|
  people['Sean'].credits = credits.to_i
end

Then(/^Larry hears both Sean's messages$/) do
  @messages_shouted_by['Sean'].each do |message|
    expect(people['Larry'].messages_heard).to include message
  end
end

Then(/^Lucy hears all Sean's messages$/) do
  @messages_shouted_by['Sean'].each do |message|
    expect(people['Lucy'].messages_heard).to include message
  end
end

Then(/^Sean should have (\d+) credits$/) do |expected_credits|
  expect(people['Sean'].credits).to eq expected_credits.to_i
end
