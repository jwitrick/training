Chef-server

#Create x chef servers based upon the saved chef-server instance
For chef-server 10.12

for i in {1..40}; do nova boot --image 7c45ef9b-0d21-48cf-aef2-e09e3fb73a41 --flavor 3 chef-server-$i; done


#Set the root password for each server
for i in {1..40}; do ./nova-setpassword.exp chef-server-$i cheftrainingserver; done

#For each chef server run bootstrap (fixes issues with rabbitmq) - NOTE: REPLACED by the huge one below the chef-client section
for i in {1..40}; do IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingserver' ssh root@$IP 'chef-solo -c /etc/chef/solo.rb -j ~/chef.json -r bootstrap-latest.tar.gz' ; done

#For each chef server update chef-server to the latest version: - NOTE: REPLACED by the huge one below the chef-client section
for i in {1..40}; do IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingserver' ssh root@$IP 'gem install chef-server' ; done

#For each chef server

#For each chef server open ports 4000, and 4040 - NOTE: REPLACED by the huge one below the chef-client section
#for i in {1..40}; do IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingserver' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP 'iptables -I INPUT 4 -p tcp --dport 4000 -j ACCEPT; iptables -I INPUT 5 -p tcp --dport 4040 -j ACCEPT; service iptables save'; done


Chef-client

#Create x chef clients based upon the saved chef-client instance
for i in {1..40}; do nova boot --image d897ea27-7781-4fb2-b12d-78d1f336006f --flavor 3 chef-client-$i; done

#Set the root password for each server
for i in {1..40}; do ./nova-setpassword.exp chef-client-$i cheftrainingnode; done

#Open port 80, 587, 3306, 443
for i in {1..40}; do IP=$(nova show chef-client-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingnode' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP 'iptables -I INPUT 4 -p tcp --dport 80 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 587 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 3306 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 443 -j ACCEPT; service iptables save'; done

#To update chef-server, open PORTS, run knife bootstrap in one command run:
for i in {1..40}; do echo "Working on #$i" ; C_IP=$(nova show chef-client-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); S_IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/\ //g" );  sshpass -p 'cheftrainingserver' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$S_IP "chef-solo -c /etc/chef/solo.rb -j ~/chef.json -r bootstrap-latest.tar.gz ; sed -i \"s/chef_server_url.*/chef_server_url\ \ \ \ \ 'http\:\/\/$S_IP\:4000'/\" /root/.chef/knife.rb ; iptables -I INPUT 4 -p tcp --dport 4000 -j ACCEPT; iptables -I INPUT 5 -p tcp --dport 4040 -j ACCEPT; service iptables save; knife bootstrap $C_IP --sudo -x root -Pcheftrainingnode"; done



#To get a list of chef-server and client servers with ips:
for i in {1..40}; do S_IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); C_IP=$(nova show chef-client-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); echo -e "$i \n\t $S_IP\n\t $C_IP\n\n"; done
