require 'shouty'

Given("Lucy is located {int}m from Sean") do |distance|
  @lucy = Shouty::Person.new
  @sean = Shouty::Person.new
  @lucy.move_to(distance)
end

When("Sean shouts {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("Lucy hears Sean's message") do
  pending # Write code here that turns the phrase above into concrete actions
end
