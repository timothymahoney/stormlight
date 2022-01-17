# Homelab

## Synopsis

My goal is to run a small Kubernetes cluster for local use. This repository acts as the source of truth for what's deployed there.

I didn't want to utilize large pieces of hardware like legit rack servers, for a few reasons:

* space
* noise 
* power consumption

The naming of the homelab is based on [Brandon Sanderson's Stormlight Archive](https://www.brandonsanderson.com/books-and-art/) novels, mostly because I stumbled across a blog post and liked the idea, and also the books are great.

## Hardware
* bondsmith
  * [Raspberry Pi 4 4GB](https://www.amazon.com/CanaKit-Raspberry-4GB-Starter-Kit/dp/B07V5JTMV9)
* edgedancer
  * [Intel Nuc i7](https://www.newegg.com/intel-rnuc11pahi70001/p/N82E16856102275?Item=N82E16856102275) 
  * 64GB 3200Mhz RAM
  * 500GB NVME Drive
* lightweaver
  * [Intel Nuc i7](https://www.newegg.com/intel-rnuc11pahi70001/p/N82E16856102275?Item=N82E16856102275) 
  * 64GB 3200Mhz RAM
  * 500GB NVME Drive
* windrunner
  * [Intel Nuc i7](https://www.newegg.com/intel-rnuc11pahi70001/p/N82E16856102275?Item=N82E16856102275) 
  * 64GB 3200Mhz RAM
  * 500GB NVME Drive
* truthwatcher
  * [Synology DiskStation DS220+](https://www.newegg.com/synology-ds220/p/N82E16822108743?Item=N82E16822108743)
  * 2x 4TB NAS Drives
* Linksys 8 Port switch

## Network Map

Image: TODO. I'm hooking the devices into the switch reserved static IPs for all devices in my router. 

`bondsmith` is going to act as the kubernetes control plane, and the NUCs as agents. `truthwatcher` is going to be an NFS server for storage, potentially a docker registry if I can figure it out.

I didn't want to use Raspberry Pis for the entire cluster because I don't want to have to go hunting ARM docker images all the time. I'm going to taint `bondsmith` to not run any pods and just act as the control plane. The NUCs are x86_64, so they can run normal images.

I recently got the itch to set up a home lab, and wanted to upgrade my network equipment. I saved up a bit and got a Ubiquiti Dream Machine Pro and a 16 Port switch, among a few other things. 

Cluster Topology:
* bondsmith: 192.168.1.100
* edgedancer: 192.168.1.101
* lightweaver: 192.168.1.102
* windrunner: 192.168.1.103
* truthwatcher: 192.168.1.109 & 110

## Software

### Ubuntu Server

I've been using Ubuntu desktop with i3 for a few years now, and I love it. In AWS I generally utilize Amazon Linux 2 for running EKS clusters, but I'm going to use ubuntu server 20.04 on these devices.

The excellent RPI-Imager tool was able to image ubuntu server 64 bit onto the SD Card I purchased, so getting that up was relatively painless. I got into the box and modified netplan to utilize the static IP.

I imaged a USB key with ubuntu server 20.04 for the NUCs, and installed it. I don't have a router that works with UEFI PXE boot unfortunately (future purchase?) so remote booting them wasn't an option. Would have been cool. I utilized netplan to set up static IPs for each box.

### Docker

I'm using a normal docker install. 

### K3s

K3s stood up relatively easily for me, but I removed Traefic and Flannel, opting for Calico and NGINX Ingress Controller. I don't have a reason for doing so other than familiarity... but the idea that I had to custom make ingress crd resources for Traefik botherered me, mostly because I enjoy being able to just deploy Helm charts without having to do a bunch of extra work to get them working. Am I wrong? Please feel free to enlighten me, I'm always interesting in learning alternative methods!

### Joining nodes

On the master I had to grab the node state thing in order to assemble a join command that I then ran on the agents.

### Secrets

Probably Vault with an NFS mount on my NAS so that I have resiliency, and I like Kubernetes External Secrets so I can utilize that.