## DESCRIPTION: creates a custom cloudformation template
##
## USAGE: ruby assignment.rb --instances num_of_instances \
## --instance-type ec2_instance_type \
## --allow-ssh-from allowed_ip_or_net_address --port port_to_open
## Arguments are optional and can be escaped
##
## EXAMPLES
## ruby assignment.rb
## ruby assignment.rb --instances 2 --instance_type t1.small \
## --allow-ssh-from 192.168.55.0/24
##
## AUTHOR: Mehdi Kianpour
## DATE: May, 2015

###---------------------------------------------------------------------
# This class has necessary methods to generate proper cfn template
# some cfn template parameters can be passed to the methods of this class
class TemplateCreator
  attr_reader :path
  attr_reader :out_json
  # When initialized, a pre-generated fix template will be loaded
  def initialize(path_name)
    @path = path_name
    file_name = "#{path_name}/general.json"
    if File.exist? file_name
      generic_file = open(file_name)
      @out_json = generic_file.read
    else
      puts 'Template not found.'
      exit(1)
    end
  end

  # This function prepares EC2Instance part of cfn template
  # with proper values that are fed as parameter, generates appropriate string
  # to be added inside Resources block
  def prep_ec2(ec2type, index)
    file_name = "#{@path}/ec2.json"
    if File.exist? file_name
      ec2_file = open(file_name)
      ec2_str = ec2_file.read
      ec2_str = (index != 1 ? ec2_str.gsub('EC2Instance', "EC2Instance#{index}") : ec2_str)
      new_str = ec2_str.gsub("\"InstanceType\": ", "\"InstanceType\": \"#{ec2type}\"")
    else
      puts 'EC2 Template not found.'
    end
  end

  # This function prepares InstanceSecurityGroup part of cfn template
  # with proper values that are fed as parameter, generates appropriate string
  # to be added inside Resources block
  def prep_sec_group(aclnet, port)
    file_name = "#{@path}/secgrp.json"
    if File.exist? file_name
      sec_file = open(file_name)
      sec_str = sec_file.read.to_str
      newsec_str = sec_str.gsub("\"FromPort\": ", "\"FromPort\": \"#{port}\"")
      newsec_str = newsec_str.gsub("\"ToPort\": ", "\"ToPort\": \"#{port}\"")
      aclnet = (!aclnet.include? '/') ? (aclnet + '/32') : aclnet
      newsec_str = newsec_str.gsub("\"CidrIp\": ", "\"CidrIp\": \"#{aclnet}\"")
    else
      puts 'Sec Group Template not found.'
    end
  end

  # This functiom adds generated strings to final cfn template in proper place
  # Based on general template, it finds second last occurance of } char before
  # which is the end of Resources block
  def insert_in_template(str_to_ins)
    lasti = @out_json.rindex('}')
    onetolast = @out_json.rindex('}', lasti - 1)
    @out_json = @out_json.insert(onetolast - 2, str_to_ins)
  end
end

## ---------------------------------------------------------------
# Number of instances, will be defined by user or default value: 1
num_instances = 1
# ec2 instance type, will be defined by user or default value: t1.micro
ec2_type = 't2.micro'
# Allowed subnets to access, will be defined by user or default value:
acl_net = '0.0.0.0/0'
# Allowed to and from port, will be defined by user or default value: 22
tcp_port = 22

# This ruby style loop gets possible arguments by parsing
# parameters recognized by -- and sets the correspondant value
ARGV.slice_before(/^--/).each do |name, value|
  case name
  when '--instances'
    num_instances = value.to_i
  when '--instance-type'
    ec2_type = value
  when '--allow-ssh-from'
    acl_net = value
  when '--port'
    tcp_port = value.to_i
  end
end

# An object from TemplateCreator class is instanciated and
# appropriate methods are called to generate the cfn template
gen_template = TemplateCreator.new('./templates')
(1..num_instances).each do |i|
  ec2str = gen_template.prep_ec2(ec2_type, i)
  gen_template.insert_in_template(ec2str)
end
secstr = gen_template.prep_sec_group(acl_net, tcp_port)
gen_template.insert_in_template(secstr)
puts gen_template.out_json
