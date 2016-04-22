resource "null_resource" "intermediates" {
  triggers = {
    vpc_name = "classroom-${var.customer}-vpc"
    subnet_name = "classroom-${var.customer}-subnet"
    route_name = "classroom-${var.customer}-routes"
    gw_name = "classroom-${var.customer}-gw"
    sg_name = "classroom-${var.customer}-sg"
    acl_name = "classroom-${var.customer}-acl"
  }
}

resource "aws_vpc" "classroom-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags {
        Name = "${null_resource.intermediates.triggers.vpc_name}"
    }
}

resource "aws_internet_gateway" "classroom-gw" {
    vpc_id = "${aws_vpc.classroom-vpc.id}"

    tags {
        Name = "${null_resource.intermediates.triggers.gw_name}"
    }
}

resource "aws_route_table" "classroom-routes" {
    vpc_id = "${aws_vpc.classroom-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.classroom-gw.id}"
    }
    tags {
        Name = "${null_resource.intermediates.triggers.route_name}"
    }
}

resource "aws_subnet" "classroom-subnet" {
    vpc_id = "${aws_vpc.classroom-vpc.id}"
    cidr_block = "10.0.0.0/24"
    availability_zone = "${var.region}a"
    tags {
        Name = "${null_resource.intermediates.triggers.subnet_name}"
    }
}

resource "aws_route_table_association" "classroom-route_association" {
    subnet_id = "${aws_subnet.classroom-subnet.id}"
    route_table_id = "${aws_route_table.classroom-routes.id}"
}

resource "aws_network_acl" "classroom-acl" {
    vpc_id = "${aws_vpc.classroom-vpc.id}"
    subnet_ids = ["${aws_subnet.classroom-subnet.id}"]
    egress {
        protocol = -1
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }

    ingress {
        protocol = -1
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }

    tags {
        Name = "${null_resource.intermediates.triggers.acl_name}"
    }
}

resource "aws_security_group" "classroom-sg" {
  name = "${null_resource.intermediates.triggers.sg_name}"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.classroom-vpc.id}"
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 7001
      to_port = 7001
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 4001
      to_port = 4001
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 443
      to_port = 443
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 2379
      to_port = 2379
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 2380
      to_port = 2380
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Essentials-Workstation" {
  depends_on = ["aws_internet_gateway.classroom-gw"]
  availability_zone = "${var.region}a"
  count = "${var.node_num}"
  ami = "ami-913625fb"
  instance_type = "t1.micro"
  key_name = ""
  vpc_security_group_ids = ["${aws_security_group.classroom-sg.id}"]
  subnet_id = "${aws_subnet.classroom-subnet.id}"
  associate_public_ip_address = true
  connection {
    user = "chef"
    password = "chef"
  }
  tags {
      Name = "${format("${var.customer}-Essentials-Workstation-%02d", count.index + 1)}"
      Trainer = "${var.trainer}"
      Department = "${var.department}"
      Customer = "${var.customer}"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
    delete_on_termination = true
  }
  provisioner "remote-exec" {
    inline = [
    "ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
    "host=$(hostname -f)",
    "echo \"export ETCD_OPTS=\\\"--name=$host --data-dir=/tmp/$host.etcd --initial-advertise-peer-urls http://$ip:2380 --listen-peer-urls http://0.0.0.0:2380,http://0.0.0.0:7001 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 --advertise-client-urls=http://$ip:2379,http://$ip:4001 --discovery ${var.disco}\\\"\" | sudo tee /etc/environment",
    "sudo service iptables stop",
    "sudo service etcd start",
    "sleep 60 && etcdctl mkdir /workstations/$host && etcdctl set /workstations/$host/1 {\\\"IP\\\":\\\"$ip\\\"}"
    ]
  }
}

resource "aws_instance" "Essentials-Guacamole-Server" {
    depends_on = ["aws_internet_gateway.classroom-gw"]
    count = 1
    ami = "ami-1c302376"
    instance_type = "c3.large"
    key_name = ""
    vpc_security_group_ids = ["${aws_security_group.classroom-sg.id}"]
    subnet_id = "${aws_subnet.classroom-subnet.id}"
    associate_public_ip_address = true
    connection {
      user = "chef"
      password = "chef"
    }
    tags {
        Name = "${var.customer}-Essentials-Guacamole-Server"
        Trainer = "${var.trainer}"
        Department = "${var.department}"
        Customer = "${var.customer}"
    }
    root_block_device {
      volume_type = "gp2"
      volume_size = "20"
      delete_on_termination = true
    }
    provisioner "remote-exec" {
      inline = [
        "sudo ufw disable",
        "ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
        "host=$(hostname -f)",
        "echo \"export ETCD_OPTS=\\\"--name=$host --data-dir=/tmp/$host.etcd --initial-advertise-peer-urls http://$ip:2380 --listen-peer-urls http://0.0.0.0:2380,http://0.0.0.0:7001 --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 --advertise-client-urls=http://$ip:2379,http://$ip:4001 --discovery ${var.disco}\\\"\" | sudo tee /etc/environment",
        "sudo service etcd start",
        "sleep 90 && students=\"${var.student_list}\"; etcdctl mkdir /students/$students && etcdctl set /students/$students/1 {\\\"NAME\\\":\\\"$students\\\"}",
        "sleep 30 && sudo su -c \"confd -config-file='/etc/confd/confd.toml' &\""
      ]
    }
  }
