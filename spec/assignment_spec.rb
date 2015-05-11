require_relative '../assignment'
require_relative 'spec_helper'


str1 = open('./spec/ec2spec1.txt').read
str2 = open('./spec/secspec1.txt').read
str3 = open('./spec/output1.txt').read

describe TemplateCreator do

  before :each do
    @tmpl = TemplateCreator.new('./templates')
  end

  describe '#prepare_ec2' do
    it 'prepares ec2 instance sub-block of resources' do
      expect(@tmpl.prep_ec2('t2.small',1)).to eq str1
    end
  end
  describe '#prepare_sec_group' do
    it 'prepares security group instance sub-block of resources' do
      expect(@tmpl.prep_sec_group("192.168.10.50", 24)).to eq str2
    end
  end
  describe '#prepares_final_template' do
    it 'prepares final cfn compatible template' do
      ec2str = @tmpl.prep_ec2('t2.micro',1)
      @tmpl.insert_in_template(ec2str)
      secstr = @tmpl.prep_sec_group('0.0.0.0/0', 22)
      @tmpl.insert_in_template(secstr)
      expect(@tmpl.out_json).to eq str3
    end
  end
end
