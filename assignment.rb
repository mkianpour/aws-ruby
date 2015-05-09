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

require "json"


class TemplateCreator
    
    attr_reader :path
    attr_reader :out_json
    
    def initialize(path_name)
        @path = path_name
        file_name = "#{path_name}/general.json"
        if File.exists? file_name
            generic_file = open(file_name)
            @out_json = generic_file.read
        else
            puts "Template not found."
            exit(1)
        end
    
    end


    def prepare_ec2instance(ec2type)
        file_name = "#{@path}/ec2.json"
        if File.exists? file_name
            ec2_file = open(file_name)
            ec2_str = ec2_file.read.to_str
            new_str = ec2_str.gsub("\"InstanceType\":", "\"InstanceType\": \"#{ec2type}\"")
            insert_in_template(new_str)     
        else
            puts "EC2 Template not found."
        end
    end
    
    def prepare_sec_group(aclnet,port)
        file_name = "#{@path}/secgrp.json"
        if File.exists? file_name
            sec_file = open(file_name)
            sec_str = sec_file.read.to_str
            newsec_str = sec_str.gsub("\"FromPort\":", "\"FromPort\": \"#{port}\"")
            newsec_str = newsec_str.gsub("\"ToPort\":", "\"ToPort\": \"#{port}\"")
            if !aclnet.include? '/'
                aclnet = aclnet + '/32'
            end
            newsec_str = newsec_str.gsub("\"CidrIp\":", "\"CidrIp\": \"#{aclnet}\"")      
            insert_in_template(newsec_str)     
        else
            puts "Sec Group Template not found."
        end  
    end

    def insert_in_template(str_to_ins)
        lasti = @out_json.rindex('}')
        onetolast = @out_json.rindex('}',lasti-1)
        @out_json = @out_json.insert(onetolast-1, str_to_ins+"\n")
    end
    
end

##---------------------------------------------------------------
#Number of instances, will be defined by user or default value: 1
num_instances = 1

#ec2 instance type, will be defined by user or default value: t1.micro
ec2_type = "t1.micro"

#Allowed subnets to access, will be defined by user or default value:
acl_net = "0.0.0.0/0"

#Allowed to and from port, will be defined by user or default value: 22
tcp_port = 22

#This ruby style loop gets possible arguments by parsing
#parameters recognized by -- and sets the correspondant value
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

gen_template = TemplateCreator.new("./templates")

(1..num_instances).each do 
    gen_template.prepare_ec2instance(ec2_type)
end
gen_template.prepare_sec_group(acl_net, tcp_port)
puts gen_template.out_json
