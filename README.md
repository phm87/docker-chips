# docker-chips

Still in development, DO NOT USE EXCEPT IF YOU KNOW WHAT YOU ARE DOING


## docker installation:

Docker can be installed on many OS.

### ubuntu 16.04


```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker
```
Source : https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

## build and run this dockerfile:
Build the image:
```shell
git clone https://github.com/phm87/docker-chips
cd docker-chips
docker build . -t chips
```
Run a container:
sudo docker run -it <imagename>

Run a container in detached mode:
sudo docker run -itd <imagename>
