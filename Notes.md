# The brain-dump and notes file for ongoing development

I'm making this file available to hopefully make my application process more appealing. This is so the reviewers of the exercise have context for decisions, can evaluate my thought process, and see how I work.

This file will vary according to version control / commit history so if you want to look at how I change my thoughts on things over time, go through the commit history

## Assumptions

I'm going to take every instruction very literally and only implement best-practices when it doesn't conflict with the instructions. In theses exercises there's always some ambiguity (on purpose) so you have to make assumptions. I've done a couple of these, and the safe route is always to respect every specific instruction in the exercise. 

## dependencies:

I want this thing to be portable for 1. Its good practice 2. I dont want to be embarrassed when I present in someone else's laptop. That being said, there's going to be some dependencies:


- Docker (or some docker-compatible container engine + cli like podman with alias docker)
  - with build capabilities (I dont think I'll require buildx / buildtools, but its optional for faster building)

- Maybe minikube? I'll see if I can run minikube tool as container, since the node already is a container.
  - https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/

```bash

"""The socket solution

Let’s take a step back here. Do you really want Docker-in-Docker? Or do you just want to be able to run Docker (specifically: build, run, sometimes push containers and images) from your CI system, while this CI system itself is in a container?

I’m going to bet that most people want the latter. All you want is a solution so that your CI system like Jenkins can start containers.

And the simplest way is to just expose the Docker socket to your CI container, by bind-mounting it with the -v flag.

Simply put, when you start your CI container (Jenkins or other), instead of hacking something together with Docker-in-Docker, start it with:"""

docker run -v /var/run/docker.sock:/var/run/docker.sock ...  

```
  - basically I just need a container of minikube binary with mounted container runtime socket so it can launch and control the "nodes". I think thats enough. 
  - Another way of making this portable is to just download the right binary for each arch.

  - 


entrypoint: deploy.sh

## Kubernetes Cluster & Minikube tool

- Terraform/cdktf code that creates all the necessary components to reach the desired architecture.
  - This means It provisions the "cluster" too I guess ??
- **Istio** and **App** are **Helm-packaged** and **installed using Terraform**. You can use Helm Charts from thecommunity.
- Requests to App are routed exclusively through Istio as App is not exposed outside of the cluster.
- `Istio Ingress` is published on TCP port 30080.
- Requests are routed to App only if they include the HTTP Host header api.app.com.
- App is a **simple web server of your choice** that **responds to GET /info** requests by returning the Pod’s IP address in both the response body and a custom response header. See the screenshot below for more details

SO:
- ISTIO
  - https://istio.io/latest/docs/setup/install/helm/
- APP
  - dockerfile + custom helm package w/ deployment

https://github.com/kreuzwerker/terraform-provider-docker

versions: 

minikube version: v1.37.0
--kubernetes-version=v1.34.0
        The Kubernetes version that the minikube VM will use (ex: v1.2.3, 'stable' for v1.34.0, 'latest' for v1.34.0). Defaults to 'stable'.

straight binary

minikube linux x86 https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-linux-amd64

tarball
https://github.com/kubernetes/minikube/releases/download/v1.37.0/minikube-linux-amd64.tar.gz

ISO Checksums

checksum
 linux-amd64: d5cf561c71171152ff67d799f041ac0f65c235c87a1e9fc02a6a17b8226214d0

darwin-amd64: 4c32b9e5fed64a311db9a40d6fdcc8fa794bc5bbc546545f4d187e9d416a74cb
darwin-arm64: 5e0914c3559f6713295119477a6f5dc29862596effbfc764a61757bb314901d2

Since there isn't an official minikube tool container image (or there is and its just obscure or doesnt have user-friendly docs so I couldnt find it) I'll just pull and run binaries from official releases since it's just as portable as a container (which is also architecture-dependant), only extra variable here being the OS, so I will support any linux that can run containers, macOS darwin and Windows WITH wsl, pure windows will be negleted due to time and patience constraints and I dont have a windows machine and dont want to spin up a windows VM to test it. Everyone who does development on windows uses wsl anyway.

**pulling the right binary**
To detect architecture:
```bash
arch
```

## Ingress from AWS ALB to Istio

The most fundamental question is whether I should treat the cluster as part of cloud infrastructure or an on-site deployment. On the architecture diagram, minikube is clearly outside of the "moto" group. I'm treating the moto group as "aws infrastructure", so in that way, minikube is a cluster that sits outside of the AWS cloud. This means it wont belong to an AWS vpc, wont be run on mock ec2 instances, etc. Its effectively an "on-prem" kubernetes deployment.

https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/aws-direct-connect-aws-transit-gateway.html

I don't know if they expect me to go this far in treating it as "real" infra, and I dont know how much support moto has for emulating this stuff. I will setup the basic idea of pointing the alb to a fixed ip / domain 




## Moto

Proxy mode
They specifically say moto in proxy mode over moto in server / standalone mode. I'd rather use it as standalone and specify AWS endpoints but ok:

To set the proxy endpoint, use the HTTPS_PROXY-environment variable.

Because the proxy does not have an approved SSL certificate, the SDK will not trust the proxy by default. This means that the SDK has to be configured to either

    Accept the proxy’s custom certificate, by setting the AWS_CA_BUNDLE-environment variable

    Allow unverified SSL certificates

The AWS_CA_BUNDLE needs to point to the location of the CA certificate that comes with Moto.
You can run moto_proxy –help to get the exact location of this certificate, depending on where Moto is installed.

So if I want to run this thing as a container I need to get the CA bundle outside of the container. I can either ship the code with the CA bundle because I dont think it varies for a specific version (like I dont think its randomly seeded key creation) so it should be ok. And just have terraform use proxy localhost:5000 and aws ca bundle of moto. That should work.

