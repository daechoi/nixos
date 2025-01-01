On Mac silicon
colima start --arch x86_64 did not..

colima start --vm-type vz als worked.

# nomad in this network

sudo nomad agent -dev -bind=0.0.0.0 -network-interface=en0

# Starts Consl in t same network

consul agent -dev -client=0.0.0.0 -bind=192.168.8.231

all your services will be registered in consul using the righ IP and your tasks will be able to reach each other.

To access your tasks from your host machine you will need t use the network interface IP address

curl http://192.168.8.231:8080

Next, you will need to query Consul to retrieve the right IP and port for the mysql service. There are a few ways that you can do that, but using consul-template is probably the easiest one, so update your wordpress.nomad job like this (remove the +/-, I added those just for the syntax highlight):

```
job "wordpress" {
  # ...
  group "wordpress" {
    # ...
    task "wordpress" {
      # ...
      env {
-       WORDPRESS_DB_HOST     = "127.0.0.1:22100"
        WORDPRESS_DB_NAME     = "wordpress"
        WORDPRESS_DB_USER     = "wpuser"
        WORDPRESS_DB_PASSWORD = "wppass"
      }

+     template {
+       data        = <<EOF
+{{ range service "mysql" }}
+WORDPRESS_DB_HOST = "{{ .Address }}:{{ .Port }}"
+{{ end }}
+EOF
+       destination = "local/env"
+       env         = true
      }
  # ...
}
```

This will render a file with the value for the mysql service rendered. This fill will then be loaded as environment variables.

Question #1, why is MySQL unreachable from the WordPress job even with the ADDR hardcoded?
I know the DB works as I’m able to access my host on 127.0.0.1:22100

Because 127.0.0.1 inside your container is different from the 127.0.0.1 outside of it. You will need to use your computer’s IP.

Nomad doesn’t actually do much in terms of networking. It’s a scheduler, so it will schedule your workload and assign ports (statically or dynamically) that you can use to access them using that host’s IP.

All tasks in the same group are guaranteed to be scheduled in the same host (that’s what’s called an allocation). Since they are running in the same host, they share the same local network, so Nomad automatically places them in the same network namespace. That’s why you can access one task from another using localhost, 127.0.0.1 or runtime environment variables.

But for tasks in different groups (including tasks in different jobs), there’s now way to create this shared namespace, so you will need some kind of catalog to store and query information about these random <IP>:<port> assignments. That’s what Consul’s Service Discovery is used for.

When you create a service block in your job, Nomad will automatically register the <IP>:<port> information in Consul. You can then query this later, either using Consul’s DNS interface, Consul’s API or the template block in a Nomad job (which I used in the example).

Quick recap: Nomad uses direct <IP>:<port> assignment to expose tasks. You need a way to record all of these assignments, and that’s what Consul does.

To add a bit more to the confusion is how nomad agent -dev and Docker Desktop works.

nomad agent -dev will bind to 127.0.0.1 by default, meaning that it will only be available in the host’s local network.

Docker Desktop will run a Linux VM to start your containers. It will expose its network to your host’s network, but this VM won’t be able to reach your local network. Binding Nomad to 0.0.0.0 allow your Docker workloads to talk to each other (0.0.0.0 is default without -dev).

The next CLI attribute that you need is -network-interface. This tells Nomad which network to use when assigning ports to allocations, and also the <IP> portion when registering services.

On -dev mode, Nomad will use the loopback interface for this, but, as we’ve seen before, this will cause problems with Docker Desktop because the services will be registered with the IP 127.0.0.1. When another task reads this information from Consul, it won’t be able to actually connect to 127.0.0.1 since it’s a different network space altogether (it will be inside the container network). By using a non-loopback interface, we avoid this problem.

Service discovery is just one way to handle this. Another one is what @Clivern mentioned, which is Consul Connect.

This mode requires a Linux host, so it won’t work for you, but the idea behind it is that Nomad will automatically deploy a sidecar proxy alongside your tasks. Consul will then automatically configure these proxies so they are able to communicate with each other.

So your mysql task will have one proxy, and your wordpress task will have another proxy that is pre-configured to be able to reach the mysql proxy. Since the proxies are in the same allocation, your app will be able to access it via localhost, so it will all look like a local network.

Two jobs:
Mysql:

```
job "mysql" {

    datacenters = ["dc1"]

    group "leader" {
        network {
          # Request for a static port
          port "mysql" { to = 3306}
        }
        task "mysql" {

            driver = "docker"

            config {
                image = "mysql"
                ports=["mysql"]
            }
            env {
                MYSQL_ROOT_PASSWORD = "root"
                MYSQL_DATABASE = "wordpress"
                MYSQL_USER = "wpuser"
                MYSQL_PASSWORD = "wppass"
            }
            service {
                name = "mysql"
                tags = ["global"]
                port = "mysql"

                check {
                    name = "mysql ping"
                    type = "tcp"
                    interval = "30s"
                    timeout = "2s"
                }
            }
            resources {
                cpu = 500 #Mhz
                memory = 512 #MB
            }
        }
    }
}
```

Wordpress:

```
ob "wordpress" {

    datacenters = ["dc1"]


    group "wordpress" {

        network {
            port "http" { to = 80}
        }

        task "wordpress" {

            driver = "docker"

            config {
                image = "wordpress"
                ports=["http"]
            }

            env {
                WORDPRESS_DB_HOST = "127.0.0.1:22100"
                WORDPRESS_DB_NAME = "wordpress"
                WORDPRESS_DB_USER = "wpuser"
                WORDPRESS_DB_PASSWORD = "wppass"
            }

            service {
                name = "wordpress"
                port = "http"

                check {
                    name     = "500 error check"
                    type     = "http"
                    protocol = "http"
                    path     = "/"
                    interval = "30s"
                    timeout  = "2s"
                }
            }

            resources {
                cpu = 500 # Mhz
                memory = 256 # MB
            }

        }
    }
}
```
