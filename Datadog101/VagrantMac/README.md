This directory contains the Vagrant environment for the **Datadog 101** course on the Datadog Learning Site. To use this, make sure you have a working Vagrant environment. To find out more about setting up Vagrant, see https://www.vagrantup.com/. 


## Setup a Datadog Trial

For this course, you should create a new Datadog trial account. Go to https://app.datadoghq.com/account/login and click the **Sign Up** link. Step 3 of the signup process is Agent Setup. Click on any of the installation options and you will a command you need to run on a server. At the beginning of the command is **DD_API_KEY**. Copy the key and then add it to the file described below.


## Configure your API Key for you Vagrant VMs

Create a file in your home directory called `.ddtraining.sh` with the following contents:

```
#!/bin/bash
DD_API_KEY="Your API Key Here"

```

*Note: the file should have a new line after your API Key and your API Key should be wrapped in quotes.*

## Clone the repo

With Vagrant running on your machine, clone this repo. Navigate to the Datadog101/VagrantMac directory. Any time you need to run a command on **util** or start or stop your vagrant environment, you should come back to this directory. 

## Setting up the environment
Run the following command to start your Vagrant environment:

```vagrant up```

It will take a few minutes to setup the five servers. This includes an HAProxy load balancer, three Apache webservers, and a utility server to run a load testing tool against the load balancer. The load balancer is reachable at http://localhost:8081. Try the URL and refresh a few times. You should see a different result each time. 

## Resetting the environment

Anytime you want to reset the environment to its original state, run this command:

```vagrant halt;vagrant destroy -f;vagrant up```

## Stopping the environment

To stop the virtual machines you can either suspend them:

```vagrant suspend```

or halt them:

```vagrant halt```

## Running jobs on util

There are two commands you can run on util: light and heavy. These are two different loads on the load balancer. I will let you guess which is which.

To login to **util**:

```vagrant ssh util```

To run **light**:

```light```

To run **heavy**:

```heavy```

