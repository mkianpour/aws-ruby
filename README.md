# aws-ruby
## USAGE: ruby assignment.rb --instances num_of_instances \
## --instance-type ec2_instance_type \
## --allow-ssh-from allowed_ip_or_net_address --port port_to_open
## Arguments are optional and can be escaped

Class TemplateCreator main methods:

1) prep_ec2(string, int)
  # This function prepares EC2Instance part of cfn template
  # with proper values that are fed as parameter, generates appropriate string
  # to be added inside Resources block

2) prep_sec_group(string, int)
  # This function prepares InstanceSecurityGroup part of cfn template
  # with proper values that are fed as parameter, generates appropriate string
  # to be added inside Resources block

3) insert_in_template(string)
  # This functiom adds generated strings to final cfn template in proper place
  # Based on general template, it finds second last occurance of } char before
  # which is the end of Resources block

