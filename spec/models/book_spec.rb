require 'spec_helper'

describe Book do
  it { should belong_to(:consignor).class_name(User) }
end
