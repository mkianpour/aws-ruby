require_relative '../assignment'
require 'spec_helper'


str1 = '
    "EC2Instance": {

      "Properties": {

        "ImageId": "ami-b97a12ce",

        "InstanceType": "t2.small",

        "SecurityGroups": [

          {

            "Ref": "InstanceSecurityGroup"

          }

        ]

      },

      "Type": "AWS::EC2::Instance"

    },
'

describe TemplateCreator do
  describe '#prepare_ec2instance' do
    it 'prepares ec2instance sub-block' do
      expect(TemplateCreator.new('./templates').prepare_ec2instance('t2.small',1)).to eq str1
    end
  end
end
