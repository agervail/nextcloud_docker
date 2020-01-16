# Server configuration scaleway
```
apt install sudo
usermod -aG sudo antoine
mkdir /home/antoine/.ssh
cp /root/.ssh/authorized_keys /home/antoine/.ssh
chown -R antoine:antoine /home/antoine/.ssh
```
If there's a problem with sudo you then need to modify the sudoers file
```
chmod +w /etc/sudoers
vim /etc/sudoers
```
Add this line at the end of the file
```
%sudo   ALL=(ALL:ALL) ALL
```
then put it back on readonly
```
chmod -w /etc/sudoers
```

After that you can log as antoine


Then install docker
https://docs.docker.com/install/linux/docker-ce/ubuntu/
Don't forget to add your user in docker group
And to run docker on boot :
```
sudo systemctl enable docker
```
