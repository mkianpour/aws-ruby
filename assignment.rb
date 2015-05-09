## DESCRIPTION: creates a custom cloudformation template
##
## USAGE: ruby assignment.rb --instances num_of_instances --instance-type ec2_instance_type --allow-ssh-from allowed_ip_or_net_address --port port_to_open
## Arguments are optional and can be escaped
##
## EXAMPLES
## ruby assignment.rb
## ruby assignment.rb --instances 2 --instance_type t1.small --allow-ssh-from 192.168.55.0/24 
##
## AUTHOR: Mehdi Kianpour
## DATE: May, 2015


class TemplateCreator
    
    def initialize(file_name)
        if File.exists? file_name
            generic_file = open(file_name)
            puts generic_file.read
        else
            puts "Template not found."
            exit(1)
        end
    
    end


    def add_ec2instance()
    
    end
    
    def add_sec_group()
    
    end
    
end

#Number of instances, will be defined by user or default value: 1
num_instances = 1

#ec2 instance type, will be defined by user or default value: t1.micro
ec2_type = "t1.micro"

#Allowed subnets to access, will be defined by user or default value:
acl_net = "0.0.0.0/0"

#Allowed to and from port, will be defined by user or default value: 22
tcp_port = 22

puts acl_net, ec2_type, num_instances, tcp_port

gen_template = TemplateCreator.new("./templates/general.json")

