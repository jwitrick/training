Chef-server

#Create x chef servers based upon the saved chef-server instance
for i in {1..40}; do nova boot --image 7c45ef9b-0d21-48cf-aef2-e09e3fb73a41 --flavor 3 chef-server-$i; done

#Set the root password for each server
for i in {1..40}; do ./nova-setpassword.exp chef-server-$i cheftrainingserver; done

#For each chef server run bootstrap (fixes issues with rabbitmq)
for i in {1..40}; do IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingserver' ssh root@$IP 'chef-solo -c /etc/chef/solo.rb -j ~/chef.json -r bootstrap-latest.tar.gz' ; done

#For each chef server open ports 4000, and 4040
for i in {1..40}; do IP=$(nova show chef-server-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingserver' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP 'iptables -I INPUT 4 -p tcp --dport 4000 -j ACCEPT; iptables -I INPUT 5 -p tcp --dport 4040 -j ACCEPT; service iptables save'; done


Chef-client

#Create x chef clients based upon the saved chef-client instance
for i in {1..40}; do nova boot --image d897ea27-7781-4fb2-b12d-78d1f336006f --flavor 3 chef-client-$i; done

#Set the root password for each server
for i in {1..40}; do ./nova-setpassword.exp chef-client-$i cheftrainingnode; done

#Open port 80, 587, 3306, 443
for i in {1..40}; do IP=$(nova show chef-client-$i |grep accessIPv4 | tr -s [:blank:] | cut -f 3 -d "|" | sed "s/ //" ); sshpass -p 'cheftrainingnode' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$IP 'iptables -I INPUT 4 -p tcp --dport 80 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 587 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 3306 -j ACCEPT; iptables -I INPUT 4 -p tcp --dport 443 -j ACCEPT; service iptables save'; done
