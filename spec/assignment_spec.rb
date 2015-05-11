require_relative '../assignment'
require 'spec_helper'


str1 = open('./spec/ec2spec1.txt').read
str2 = open('./spec/secspec1.txt').read

describe TemplateCreator do
  describe '#prepare_ec2' do
    it 'prepares ec2 instance sub-block of resources' do
      expect(TemplateCreator.new('./templates').prep_ec2('t2.small',1)).to eq str1
    end
  end
  describe '#prepare_sec_group' do
    it 'prepares security group instance sub-block of resources' do
      expect(TemplateCreator.new('./templates').prep_sec_group("192.168.10.50", 24)).to eq str2
    end
  end

end
