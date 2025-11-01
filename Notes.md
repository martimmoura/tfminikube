Just dumping the assumptions, ideas and thought process

(draft)

dependencies:

- Docker (or some docker-compatible container engine + cli like podman with alias docker)

- Maybe minikube? I'll see if I can run minikube tool as container, and the hosts also as containers.


https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/

```
The socket solution

Let’s take a step back here. Do you really want Docker-in-Docker? Or do you just want to be able to run Docker (specifically: build, run, sometimes push containers and images) from your CI system, while this CI system itself is in a container?

I’m going to bet that most people want the latter. All you want is a solution so that your CI system like Jenkins can start containers.

And the simplest way is to just expose the Docker socket to your CI container, by bind-mounting it with the -v flag.

Simply put, when you start your CI container (Jenkins or other), instead of hacking something together with Docker-in-Docker, start it with:
```


docker run -v /var/run/docker.sock:/var/run/docker.sock ...


entrypoint: deploy.sh

## Cluster


- Terraform/cdktf code that creates all the necessary components to reach the desired architecture.
  - It provisions the cluster too I guess ??
- **Istio** and **App** are **Helm-packaged** and **installed using Terraform**. You can use Helm Charts from thecommunity.
- Requests to App are routed exclusively through Istio as App is not exposed outside of the
cluster.
- `Istio Ingress` is published on TCP port 30080.
- Requests are routed to App only if they include the HTTP Host header api.app.com.
- App is a **simple web server of your choice** that **responds to GET /info** requests by returning the Pod’s IP address in both the response body and a custom response header. See the screenshot
below for more details

SO:
- ISTIO
  - https://istio.io/latest/docs/setup/install/helm/
- APP
  - dockerfile + custom helm template w/ deployment





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





## Ingress from AWS ALB to Istio

The most fundamental question is whether I should treat the cluster as part of cloud infrastructure or an on-site deployment. This matters, because 