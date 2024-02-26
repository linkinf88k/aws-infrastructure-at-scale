# TODO: Designate a cloud provider, region, and credentials

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}


# provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity-T2" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  subnet_id     = "subnet-07d14db05693a473f"
  count         = 4

  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
/*resource "aws_instance" "Udacity-M4" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "m4.large"
  subnet_id     = "subnet-07d14db05693a473f"
  count         = 2

  tags = {
    Name = "Udacity M4"
  }
}*/

